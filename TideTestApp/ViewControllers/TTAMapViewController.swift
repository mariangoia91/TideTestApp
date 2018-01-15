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
        mapView.delegate = self
        
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
    
    func createAnnotations(places: [Place]) {
        for place in places {
            let CLLCoordType = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            mapView.addAnnotation(anno);
        }
    }
}

// MARK: - Location Manager Delegate

extension TTAMapViewController: TTALocationManagerDelegate {
    func locationFound(_ latitude: Double, longitude: Double) {
        print("found location")
        
        locationManager.stopUpdatingLocation()
        
        TTAGooglePlaceHelper.googlePlacesForLocation(lat: latitude, long: longitude) { (places) in
            self.createAnnotations(places: places)
        }
    }
}

// MARK: - MKMapViewDelegate

extension TTAMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let mapRegion = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(mapRegion, animated: true)
    }
}
