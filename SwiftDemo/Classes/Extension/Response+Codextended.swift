//
//  Response+Codextended.swift
//  SwiftDemo
//
//  Created by yMac on 2019/6/10.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation
import Codextended


extension ObservableType where E == Response {
    
    public func cd_deserialize<T: Decodable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            do {
                let mapjson = try response.mapString()
                let data = mapjson.data(using: .utf8)!
                
                // MARK: - The data couldn’t be read because it isn’t in the correct format.
                // 当model的某个属性的类型不匹配的时候会转换失败，并报以上错误
                let element = try data.decoded(as: T.self, using: JSONDecoder())
                return Observable.just(element)
                
            } catch {
                print(error.localizedDescription)
                throw error
            }
        }
    }
    
}
