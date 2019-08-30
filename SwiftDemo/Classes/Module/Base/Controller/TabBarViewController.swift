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
        
        tabBar.tintColor = KColorTabBarText
        tabBar.barTintColor = .white
        
    }
    
    func setupControllers() {
        
        let zfbHome = BaseNavigationViewController.init(rootViewController: setChildViewController(childController: DoubleScrollViewController(), title: "zfbHome", image: ""))
        let home = BaseNavigationViewController.init(rootViewController: setChildViewController(childController: HomeViewController(), title: "Home", image: ""))
        let mine = BaseNavigationViewController.init(rootViewController: setChildViewController(childController: LoginViewController(), title: "login", image: ""))
        let tab4 = BaseNavigationViewController.init(rootViewController: setChildViewController(childController: StackViewController(), title: "stack", image: ""))
        
        self.viewControllers = [zfbHome,home,mine,tab4]
        
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
