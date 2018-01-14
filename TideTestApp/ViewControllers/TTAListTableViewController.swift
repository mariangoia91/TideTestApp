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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "x"
        
        return cell
    }
}

// MARK: - Table view delegate

extension TTAListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Add action for cell selection here
    }
}

// MARK: - Location Manager Delegate

extension TTAListTableViewController: TTALocationManagerDelegate {
    func locationFound(_ latitude: Double, longitude: Double) {
        print("found location")
    }
    
    func locationFoundGetAsString(_ latitude: NSString, longitude: NSString) {
        print("lat: \(latitude) long:\(longitude)")
        
        
        locationManager.stopUpdatingLocation()
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=500&type=bar&key=AIzaSyDW6mySVrKjvCnRZyXnv78bQ7lcuxqfqQA")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                        print(url)
                        print(explanation)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()

    }
    
    func locationManagerStatus(_ status:NSString) {
        
        print(status)
    }
    
    func locationManagerReceivedError(_ error:NSString) {
        
        print(error)
        //        activityIndicator.stopAnimating()
    }
}
