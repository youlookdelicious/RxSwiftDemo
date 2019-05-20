//
//  UIViewController+Extension.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/11.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func setupTheme(theme: THEME) {
        
        var naviTitleColor   : UIColor
        var naviBarTintColor : UIColor
        var naviTintColor    : UIColor
        switch theme {
        case .white:
            naviBarTintColor = THEME_WHITE_BAR_TINT
            naviTitleColor = THEME_WHITE_BAR_TEXT
            naviTintColor = THEME_WHITE_TINT
        case .black:
            naviBarTintColor = THEME_BLACK_BAR_TINT
            naviTitleColor = THEME_BLACK_BAR_TEXT
            naviTintColor = THEME_BLACK_TINT
        }
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = naviTintColor
        navigationController?.navigationBar.barTintColor = naviBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : naviTitleColor]
    }
    
}

extension UIViewController {
    class func currentViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.first else {
            return nil
        }
        
        var tempView: UIView?
        for subview in window.subviews.reversed() {
            if subview.classForCoder.description() == "UILayoutContainerView" {
                tempView = subview
                break
            }
        }
        
        if tempView == nil {
            tempView = window.subviews.last
        }
        
        var nextResponder = tempView?.next
        
        var next: Bool {
            return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
        }
        
        while next {
            tempView = tempView?.subviews.first
            if tempView == nil {
                return nil
            }
            nextResponder = tempView!.next
        }
        return nextResponder as? UIViewController
    }
}
