//
//  TabBarViewController.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/9.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupControllers()
        
        tabBar.tintColor = KCOLOR_TAB_TEXT
        tabBar.barTintColor = .white
        
    }
    
    func setupControllers() {
        
        let home = BaseNavigationViewController.init(rootViewController: setChildViewController(childController: HomeViewController(), title: "Home", image: ""))
        let mine = BaseNavigationViewController.init(rootViewController: setChildViewController(childController: HomeViewController(), title: "Mine", image: ""))
        
        self.viewControllers = [home,mine]
        
    }
    
    func setChildViewController(childController : UIViewController ,title : String, image: String) ->(UIViewController) {
        
        childController.title = title
        childController.tabBarItem.image = UIImage.init(named: image)
        
        return childController
    }
    
    deinit {
        print("\(self.description) deinit")
    }
}
