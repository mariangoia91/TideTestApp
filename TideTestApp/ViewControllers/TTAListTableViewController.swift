//
//  TTAListTableViewController.swift
//  TideTest
//
//  Created by Marian Goia on 14/01/2018.
//  Copyright © 2018 Marian Goia. All rights reserved.
//

import UIKit

class TTAListTableViewController: UITableViewController {
    
    var locationManager = TTALocationManager.sharedInstance
    var results: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Table view data source

extension TTAListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as UITableViewCell
        
        let place = results[indexPath.row]
        
        cell.textLabel?.text = place.name
        
        return cell
    }
}

// MARK: - Table view delegate

extension TTAListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let place = results[indexPath.row]
        
        openGoogleMaps(withLocation: place.lat, long: place.long)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Helpers

extension TTAListTableViewController {
    func openGoogleMaps(withLocation lat: Double, long: Double) {
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=\(lat),\(long)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(long)&zoom=14&views=traffic")!, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - Location Manager Delegate

extension TTAListTableViewController: TTALocationManagerDelegate {
    func locationFound(_ latitude: Double, longitude: Double) {

        locationManager.stopUpdatingLocation()
        
        TTAGooglePlaceHelper.googlePlacesForLocation(lat: latitude, long: longitude) { (places) in
            self.results = places
            self.tableView.reloadData()
        }
    }
    
    func locationManagerStatus(_ status:NSString) {
        
        print(status)
    }
    
    func locationManagerReceivedError(_ error:NSString) {
        
        print(error)
        //        activityIndicator.stopAnimating()
    }
}
