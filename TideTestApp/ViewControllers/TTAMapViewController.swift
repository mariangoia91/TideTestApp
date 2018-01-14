//
//  TTAMapViewController.swift
//  TideTest
//
//  Created by Marian Goia on 14/01/2018.
//  Copyright © 2018 Marian Goia. All rights reserved.
//

import UIKit
import MapKit

class TTAMapViewController: UIViewController {

    var mapView = MKMapView()
    
    var locationManager = TTALocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Helpers

extension TTAMapViewController {
    func setupMapView() {
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        mapView.showsUserLocation = true
        
        self.view.addSubview(mapView)
        self.addMapViewAutolayoutConstraints()
    }
    
    func addMapViewAutolayoutConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false

        let mapViewLeadingConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let mapViewTrailingConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let mapViewTopConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
        let mapViewBottomConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.bottomLayoutGuide, attribute:NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        
        self.view.addConstraints([mapViewLeadingConstraint, mapViewTrailingConstraint, mapViewTopConstraint, mapViewBottomConstraint])
    }
}

// MARK: - Location Manager Delegate

extension TTAMapViewController: TTALocationManagerDelegate {
    func locationFound(_ latitude: Double, longitude: Double) {
        print("found location")
    }
    
    func locationFoundGetAsString(_ latitude: NSString, longitude: NSString) {
        print("lat: \(latitude) long:\(longitude)")
    }
    
    func locationManagerStatus(_ status:NSString) {
        
        print(status)
    }
    
    func locationManagerReceivedError(_ error:NSString) {
        
        print(error)
//        activityIndicator.stopAnimating()
    }
}
