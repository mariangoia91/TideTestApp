//
//  TTALocationManager.swift
//  TideTestApp
//
//  Created by Marian Goia on 14/01/2018.
//  Copyright © 2018 Marian Goia. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())?

class TTALocationManager: NSObject,CLLocationManagerDelegate {
    
    var delegate: TTALocationManagerDelegate? = nil
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var latitudeAsString: String = ""
    var longitudeAsString: String = ""
    
    var lastKnownLatitude: Double = 0.0
    var lastKnownLongitude: Double = 0.0
    
    /* Private variables */
    
    fileprivate var completionHandler: LocationCompletionHandler
    
    fileprivate var locationManager: CLLocationManager!
    fileprivate var locationStatus : NSString = "Calibrating"// to pass in handler
    fileprivate var verboseMessage = "Calibrating"
    
    fileprivate let verboseMessageDictionary = [CLAuthorizationStatus.notDetermined:"You have not yet made a choice with regards to this application.",
                                                CLAuthorizationStatus.restricted:"This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change this status, and may not have personally denied authorization.",
                                                CLAuthorizationStatus.denied:"You have explicitly denied authorization for this application, or location services are disabled in Settings.",
                                                CLAuthorizationStatus.authorizedAlways:"App is Authorized to use location services.",
                                                CLAuthorizationStatus.authorizedWhenInUse:"You have granted authorization to use your location only when the app is visible to you."]
    
    fileprivate override init() {
        super.init()
    }
    
    // MARK: - Singleton
    
    class var sharedInstance: TTALocationManager {
        struct Static {
            static let instance: TTALocationManager = TTALocationManager()
        }
        return Static.instance
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocationWithCompletionHandler(_ completionHandler:((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())? = nil){
        
        self.completionHandler = completionHandler
        
        initLocationManager()
    }
    
    func startUpdatingLocation() {
        initLocationManager()
    }
    
    func stopUpdatingLocation() {
        lastKnownLongitude = 0.0
        lastKnownLatitude = 0.0

        locationManager.stopUpdatingLocation()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var hasAuthorised = false
        let verboseKey = status
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access"
        case CLAuthorizationStatus.denied:
            locationStatus = "Denied access"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Not determined"
        default:
            locationStatus = "Allowed access"
            hasAuthorised = true
        }
        
        verboseMessage = verboseMessageDictionary[verboseKey]!
        
        if (hasAuthorised == true) {
            locationManager.startUpdatingLocation()
        } else {
            if (!locationStatus.isEqual(to: "Denied access")) {
                
                var verbose = ""
                verbose = verboseMessage
                
                if ((delegate != nil) && (delegate?.responds(to: #selector(TTALocationManagerDelegate.locationManagerVerboseMessage(_:))))!) {
                    
                    delegate?.locationManagerVerboseMessage!(verbose as NSString)
                    
                }
                
                if(completionHandler != nil) {
                    completionHandler?(latitude, longitude, locationStatus as String, verbose,nil)
                }
            }
            if ((delegate != nil) && (delegate?.responds(to: #selector(TTALocationManagerDelegate.locationManagerStatus(_:))))!) {
                delegate?.locationManagerStatus!(locationStatus)
            }
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let arrayOfLocation = locations as NSArray
        let location = arrayOfLocation.lastObject as! CLLocation
        let coordLatLon = location.coordinate
        
        latitude  = coordLatLon.latitude
        longitude = coordLatLon.longitude
        
        if lastKnownLatitude == 0 && lastKnownLongitude == 0 {
            lastKnownLatitude = latitude
            lastKnownLongitude = longitude
        }
        
        latitudeAsString = latitude.description
        longitudeAsString = longitude.description
        
        var verbose = ""
        
        verbose = verboseMessage
        
        if(completionHandler != nil) {
            
            completionHandler?(latitude, longitude, locationStatus as String,verbose, nil)
        }
        
        if (delegate != nil){
            
            if (latitude != lastKnownLatitude && longitude != lastKnownLongitude) {
                if((delegate?.responds(to: #selector(TTALocationManagerDelegate.locationFoundGetAsString(_:longitude:))))!){
                    delegate?.locationFoundGetAsString!(latitudeAsString as NSString,longitude:longitudeAsString as NSString)
                }
                if((delegate?.responds(to: #selector(TTALocationManagerDelegate.locationFound(_:longitude:))))!){
                    delegate?.locationFound(latitude,longitude:longitude)
                }
            }
        }
    }
}

@objc protocol TTALocationManagerDelegate : NSObjectProtocol
{
    func locationFound(_ latitude:Double, longitude:Double)
    @objc optional func locationFoundGetAsString(_ latitude:NSString, longitude:NSString)
    @objc optional func locationManagerStatus(_ status:NSString)
    @objc optional func locationManagerReceivedError(_ error:NSString)
    @objc optional func locationManagerVerboseMessage(_ message:NSString)
}
