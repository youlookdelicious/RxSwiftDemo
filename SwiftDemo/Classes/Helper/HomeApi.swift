//
//  HomeApi.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/14.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation

let homeProvider = MoyaProvider<HomeApi>()

enum HomeApi {
    
    enum HomeNetworkCategory: String {
        case all     = "all"
        case android = "Android"
        case ios     = "iOS"
        case welfare = "福利"
    }
    
    case homeList(type: HomeNetworkCategory,size: Int, index: Int)
}


extension HomeApi: TargetType {
    
    var baseURL: URL {
        return URL.init(string: kBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .homeList(let type, let size, let index):
            return "\(type.rawValue)/\(size)/\(index)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    /// 单元测试数据
    var sampleData: Data {
        return "just for test".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
//        switch self {
//        case .homeList(_, _, _):
//            return .requestPlain
//        }
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
