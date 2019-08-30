//
//  EntranceViewModel.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/15.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation




enum ValidationResult {
    case empty
    case ok
    case failed(error: String)
}

extension ValidationResult {
    /// 验证结果
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}


protocol EntranceValidationServiceProtocol {
    func validateMobile(_ mobile: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> Observable<ValidationResult>
    func validateAuthCode(_ authCode: String) -> Observable<ValidationResult>
}

class EntranceValidationService: EntranceValidationServiceProtocol {
    
    func validateMobile(_ mobile: String) -> Observable<ValidationResult> {
        if mobile.isEmpty {
            return .just(.empty)
        }
        if mobile.count == 11 {
            return .just(.ok)
        }
        return .just(.failed(error: "手机号码不正确"))
    }
    func validatePassword(_ password: String) -> Observable<ValidationResult> {
        if password.isEmpty {
            return .just(.empty)
        }
        if password.count >= 6 {
            return .just(.ok)
        }
        return .just(.failed(error: "密码长度必须 >=6"))
    }
    func validateAuthCode(_ authCode: String) -> Observable<ValidationResult> {
        if authCode.isEmpty {
            return .just(.empty)
        }
        if authCode.count >= 6 {
            return .just(.ok)
        }
        return .just(.failed(error: "长度必须 >=6"))
    }
}



class EntranceViewModel {
    
    let validatedMobile: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedAuthCode: Driver<ValidationResult>
    
    let buttonEnable: Driver<Bool>
    
    init(
        input:(mobile: Driver<String>,
        password: Driver<String>?,
        authCode: Driver<String>?
        ),
        dependency:(EntranceValidationService)
        ) {
        
        validatedMobile = input.mobile.flatMapLatest{ mobile in
            return dependency.validateMobile(mobile).asDriver(onErrorJustReturn: .failed(error: "unknown error"))
        }
        
        validatedPassword = input.password?.flatMapLatest({ (password) in
            return dependency.validatePassword(password).asDriver(onErrorJustReturn: .failed(error: "unknown error"))
        }) ?? dependency.validatePassword("").asDriver(onErrorJustReturn: .failed(error: "unknown error"))
        
        validatedAuthCode = input.authCode?.flatMapLatest({ (authCode) in
            return dependency.validateAuthCode(authCode).asDriver(onErrorJustReturn: .failed(error: "unknown error"))
        }) ?? dependency.validateAuthCode("").asDriver(onErrorJustReturn: .failed(error: "unknown error"))
        
        buttonEnable = Driver.combineLatest(validatedMobile, validatedPassword, validatedAuthCode) { mobile, password, authCode in
            mobile.isValid && (password.isValid || authCode.isValid)
        }.distinctUntilChanged()
        
    }
    
}
