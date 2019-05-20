//
//  BaseNavigationViewController.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/9.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNaviBarStyle()
        
    }
    
    
    func setNaviBarStyle() {
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = THEME_WHITE_TINT
        navigationBar.barTintColor = THEME_WHITE_BAR_TINT
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:THEME_WHITE_BAR_TEXT]
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count == 1 {
            //1. 隐藏要 push 的控制器的 tabbar
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
}
