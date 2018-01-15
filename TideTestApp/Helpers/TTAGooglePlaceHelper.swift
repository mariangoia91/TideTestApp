//
//  TTAGooglePlaceHelper.swift
//  TideTestApp
//
//  Created by Marian Goia on 15/01/2018.
//  Copyright © 2018 Marian Goia. All rights reserved.
//

import Foundation
import CoreLocation

class TTAGooglePlaceHelper {
    static func googlePlacesForLocation(lat: Double, long: Double, completion: @escaping (_ places: [Place]) -> Void) {
        var resultsArray: [Place] = []
        
        
        let apiKey = "AIzaSyDW6mySVrKjvCnRZyXnv78bQ7lcuxqfqQA"
        
        let placeType = "bar"
        let radius = 500
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=\(radius)&type=\(placeType)&key=\(apiKey)")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let jsonResults = jsonSerialized?["results"] as? [Any] {

                        for item in jsonResults {
                            
                            if let result = item as? [String:Any] {
                                
                                if let name = result["name"] as? String {
                                    
                                    if let geometry = result["geometry"] as? [String : Any] {
                                        if let location = geometry["location"] as? [String : Any] {
                                            
                                            if let resultLat = location["lat"] as? Double, let resultLong = location["lng"] as? Double {
                                                let place = Place(name: name, lat: resultLat, long: resultLong, userLat: lat, userLong: long)
                                                
                                                resultsArray.append(place)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        completion(resultsArray)
                        
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
    
    static func distanceBetweenLocations(fromLat: Double, fromLong: Double, toLat: Double, toLong: Double) -> Double {
        let fromCoordinate = CLLocation(latitude: fromLat, longitude: fromLong)
        let toCoordinate = CLLocation(latitude: toLat, longitude: toLong)
        
        return fromCoordinate.distance(from: toCoordinate) // result is in meters
    }
}
