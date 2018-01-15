//
//  Place.swift
//  TideTestApp
//
//  Created by Marian Goia on 15/01/2018.
//  Copyright © 2018 Marian Goia. All rights reserved.
//

import UIKit

class Place: NSObject {

    var name: String
    var lat, long: Double
    
    init(name: String, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long

        super.init()
    }
    
    convenience override init() {
        self.init() // calls above mentioned controller with default name
    }
}
