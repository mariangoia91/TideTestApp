//
//  TTAMainTabBarController.swift
//  TideTestApp
//
//  Created by Marian Goia on 14/01/2018.
//  Copyright © 2018 Marian Goia. All rights reserved.
//

import UIKit

class TTAMainTabBarController: UITabBarController {

    var listViewNavigationController = UINavigationController()
    var mapViewNavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    func setupTabBar() {
        initListViewController()
        initMapViewController()

        self.viewControllers = [listViewNavigationController, mapViewNavigationController]
    }
    
    func initListViewController() {
        listViewNavigationController.title = "List"
        
        let listViewController = TTAListTableViewController(nibName: nil, bundle: nil)
        listViewNavigationController.viewControllers = [listViewController]
    }
    
    func initMapViewController() {
        mapViewNavigationController.title = "Map"
        
        let mapViewController = TTAMapViewController(nibName: nil, bundle: nil)
        mapViewNavigationController.viewControllers = [mapViewController]
    }
}
