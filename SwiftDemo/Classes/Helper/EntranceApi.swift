//
//  EntranceApi.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/21.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation


let entranceProvider = MoyaProvider<EntranceApi>()

enum EntranceApi {
    
    enum LoginType: String {
        case password  = "/password"
        case authCode  = "/authCode"
        case staff     = "/staff"
    }
    
    case login(type: LoginType)
    case register
}

extension EntranceApi: TargetType {
    
    var baseURL: URL {
        return URL.init(string: kBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .login(let type):
            return type.rawValue
        case .register:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
