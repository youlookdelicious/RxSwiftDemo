//
//  BaseModel.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/14.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation

struct BaseModel: HandyJSON {
    
    var code : Int?
    var message : String?
    var data : Dictionary<String, Any>?
    
    
}
