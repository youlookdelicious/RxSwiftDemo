//
//  RequestError.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/23.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation


enum RequestError: Swift.Error {
    case `default`(String)
    case other(String)
}

extension RequestError {
    var message: String? {
        switch self {
        case .default(let message):
            return message
        case .other(let message):
            return message
        }
    }
}


// MARK: - Error Descriptions
extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .default(let message):
            return message
        case .other(let message):
            return message
        }
    }
}
