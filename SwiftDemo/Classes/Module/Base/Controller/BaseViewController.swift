//
//  BaseViewController.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/9.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
    }
    
    

}

extension UIViewController {
    
    func logout() {
        UserDefaults.standard.setValue(false, forKey: "loginStatus")
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
    }
}
