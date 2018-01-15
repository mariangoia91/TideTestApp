//
//  UIViewController+ActivityIndicator.swift
//  TideTestApp
//
//  Created by Marian Goia on 15/01/2018.
//  Copyright © 2018 Marian Goia. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func displayNavBarActivity() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.startAnimating()
        let item = UIBarButtonItem(customView: indicator)
        
        self.navigationItem.leftBarButtonItem = item
    }
    
    func dismissNavBarActivity() {
        self.navigationItem.leftBarButtonItem = nil
    }
}
