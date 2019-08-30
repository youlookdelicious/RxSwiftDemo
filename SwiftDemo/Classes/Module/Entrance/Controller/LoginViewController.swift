//
//  LoginViewController.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/15.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    fileprivate let bag : DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setupObserver()
        
        let viewModel = EntranceViewModel.init(
            input: (mobile: accountTextField.rx.text.orEmpty.asDriver(),
                    password: passwordTextField.rx.text.orEmpty.asDriver(),
                    Optional.none),
            dependency: EntranceValidationService())
        
//        viewModel.buttonEnable
//            .drive(onNext: { [weak self] (valid) in
//                self?.signInButton.isEnabled = valid
//        }, onCompleted: nil, onDisposed: nil)
//            .disposed(by: bag)
        self.signInButton.isEnabled = true
        
        signInButton.rx.tap
            .subscribe(onNext: { (_) in
                UserDefaults.standard.setValue(true, forKey: "loginStatus")
                UIApplication.shared.keyWindow?.rootViewController = TabBarViewController()
            }, onError: nil,
               onCompleted: nil,
               onDisposed: nil)
            .disposed(by: bag)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.setValue(false, forKey: "loginStatus")
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
    }
    
    deinit {
        print("\(self.description) deinit")
    }
    
}

extension LoginViewController {
    
    fileprivate func setupObserver() {
        
//        let accountObservable = accountTextField.rx.text.map( {self.isValidPhone(phone: $0!)} )
//
//        let passwordObservable = passwordTextField.rx.text.map( {self.isValidPassword(password: $0!)} )
        
//        _ = passwordTextField.rx.text.map { self.isValidPhone(phone: $0!) }
        
        
        //passwordTextField.rx.text.orEmpty.map(<#T##transform: (String) throws -> R##(String) throws -> R#>)
        
//        passwordTextField.rx.text.orEmpty.map { (text) -> String in
//            text
//        }
//        passwordTextField.rx.text.orEmpty.map { $0 }
//        passwordTextField.rx.text.orEmpty.map { $0.count >= 6 }
//        passwordTextField.rx.text.orEmpty.map ( { return $0.count >= 6 } )
//        passwordTextField.rx.text.orEmpty.map {text in text.count >= 6 }
        
        
        Observable.combineLatest(accountTextField.rx.text, accountTextField.rx.text) { (account, password) -> Bool in
            return (self.isValidPhone(phone: account)) && (self.isValidPassword(password: password))
            }.subscribe(onNext: { [weak self] (canSignIn) in
                self?.signInButton.isEnabled = canSignIn
                }, onCompleted:{
                    print("completed")
            }, onDisposed: {
                print("disposed")
            }).disposed(by: bag)
        
        
        signInButton.rx.tap
            .subscribe(onNext: { (_) in
                UserDefaults.standard.setValue(true, forKey: "loginStatus")
                UIApplication.shared.keyWindow?.rootViewController = TabBarViewController()
            }, onError: nil,
               onCompleted: nil,
               onDisposed: nil)
        .disposed(by: bag)
        
    }
    
    fileprivate func isValidPhone(phone: String?) -> Bool {
        if let phone = phone {
            return phone.count == 11
        } else {
            return false
        }
    }
    fileprivate func isValidPassword(password: String?) -> Bool {
        if let password = password {
            return password.count >= 6
        } else {
            return false
        }
    }
    
}


// MARK: - actions
extension LoginViewController {
    
    
    @IBAction func signUpAction(_ sender: Any) {
    }
    
}
