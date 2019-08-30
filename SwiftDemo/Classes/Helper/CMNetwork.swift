//
//  CMNetwork.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/13.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit

///成功
typealias SuccessClosure = (_ baseModel : BaseModel) -> Void
///失败
typealias FailureClosure = (_ errorMsg : String?) -> Void

public class CMNetwork {
    ///共享实例
    static let shared = CMNetwork()
    private init(){}
    private var failInfo = ""
    
    /// 请求数据 有WaitingDialog
    func requestWithDiaLog<T:TargetType>(target : T, successClosure: @escaping SuccessClosure, FailureClosure: @escaping FailureClosure ) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target), plugins:[networkPlugin()])
        let _ = requestProvider.request(target) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    let mapjson = try response.mapString()
                    if let model = JSONDeserializer<BaseModel>.deserializeFrom(json: mapjson) {
                        successClosure(model)
                    } else {
                        FailureClosure("baseModel转换失败")
                    }
                } catch {
                    self.failInfo = "数据解析失败"
                    FailureClosure(self.failInfo)
                }
            case let .failure(error):
                self.failInfo = "请求失败"
                FailureClosure(error.errorDescription)
            }
        }
    }
    
    /// 请求数据 无WaitingDialog
    func request<T:TargetType>(target: T, successClosure: @escaping SuccessClosure, FailureClosure: @escaping FailureClosure ) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        
        let _ = requestProvider.request(target) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    let mapjson = try response.mapString()
                    if let model = JSONDeserializer<BaseModel>.deserializeFrom(json: mapjson) {
                        successClosure(model)
                    } else {
                        FailureClosure("model转换失败")
                    }
                } catch {
                    self.failInfo = "数据解析失败"
                    FailureClosure(self.failInfo)
                }
            case let .failure(error):
                self.failInfo = "请求失败"
                FailureClosure(error.errorDescription)
            }
        }
    }
    
    
    ///设置一个公共请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target: T) -> MoyaProvider<T>.RequestClosure {
        let requestTimeoutClosure = { (endpoint:Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 20 //设置请求超时时间
                done(.success(request))
            } catch {
                return
            }
        }
        return requestTimeoutClosure
    }
    
    private func networkPlugin() -> NetworkActivityPlugin {
        //设置一个loading
        let networkPlugin = NetworkActivityPlugin { (type,target) in
            switch type {
            case .began:
                SVProgressHUD.show()
            case .ended:
                if self.failInfo.isEmpty {
                    SVProgressHUD.dismiss()
                } else {
                    SVProgressHUD.showError(withStatus: self.failInfo)
                }
            }
        }
        return networkPlugin
    }
}
