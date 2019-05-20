//
//  ViewModelType.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/17.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation

protocol InOutTransform {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
