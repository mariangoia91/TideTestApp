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
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        self.displayNavBarActivity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Helpers

extension TTAMapViewController {
    fileprivate func setupMapView() {
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        mapView.showsUserLocation = true
        
        self.view.addSubview(mapView)
        self.addMapViewAutolayoutConstraints()
    }
    
    fileprivate func addMapViewAutolayoutConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let mapViewLeadingConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let mapViewTrailingConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let mapViewTopConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
        let mapViewBottomConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.bottomLayoutGuide, attribute:NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        
        self.view.addConstraints([mapViewLeadingConstraint, mapViewTrailingConstraint, mapViewTopConstraint, mapViewBottomConstraint])
    }
    
    fileprivate func createAnnotations(places: [Place]) {   // Creates map pins
        clearAnnotations() // cleanup to avoid overlapping
        
        for place in places {
            let CLLCoordType = CLLocationCoordinate2D(latitude: place.lat, longitude: place.long);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            anno.title = place.name
            anno.subtitle = "\(String(format: "%.f", arguments: [place.distanceFromUser]))m"
            mapView.addAnnotation(anno);
        }
    }
    
    fileprivate func clearAnnotations() {   // Cleans all annotations off the map
        for annotation in self.mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
    }
}

// MARK: - Location Manager Delegate

extension TTAMapViewController: TTALocationManagerDelegate {
    func locationFound(_ latitude: Double, longitude: Double) {
        locationManager.stopUpdatingLocation() // We stop listening for the location as the requirement does not ask for CONTINUOUS retrieval of places in close proximity to the user
        
        TTAGooglePlaceHelper.googlePlacesForLocation(lat: latitude, long: longitude) { (places) in

            DispatchQueue.main.async {
                // Create the pins
                self.createAnnotations(places: places)
                
                //            // Center the map, animated
                let mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(latitude, longitude), span: MKCoordinateSpanMake(0.1, 0.1))
                self.mapView.setRegion(mapRegion, animated: true)
                
                // Dismiss the activity indicator
                self.dismissNavBarActivity()
            }
        }
    }
}
