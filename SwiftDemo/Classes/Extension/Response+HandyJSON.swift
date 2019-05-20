//
//  Response+HandyJSON.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/16.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation

// MARK: Response -> Model
extension Response {
    
    public func cm_deserialize<T: HandyJSON>(_ type: T.Type) throws -> T {
        
        do {
            let mapjson = try self.mapString()
            if let object = JSONDeserializer<T>.deserializeFrom(json: mapjson) {
                return object
            } else {
                throw MoyaError.jsonMapping(self)
            }
        } catch {
            throw MoyaError.jsonMapping(self)
        }
    }
}

// MARK: Response -> Observable<T>
extension ObservableType where E == Response {
    
    public func cm_deserialize<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap{ response -> Observable<T> in
            
            do {
                let mapjson = try response.mapString()
                if let element = JSONDeserializer<T>.deserializeFrom(json: mapjson) {
                    return Observable.just(element)
                } else {
                    throw MoyaError.jsonMapping(response)
                }
            } catch {
                throw MoyaError.jsonMapping(response)
            }
        }
    }
}
