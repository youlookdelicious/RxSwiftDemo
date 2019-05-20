//
//  HomeModel.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/14.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation

struct HomeModel: HandyJSON {
    var error: Bool?
    var results: [HomeList]?
}


struct HomeList: HandyJSON {
    var _id         = ""
    var createdAt   = ""
    var desc        = ""
    var publishedAt = ""
    var source      = ""
    var type        = ""
    var url         = ""
    var used        = ""
    var who         = ""
}


struct HomeSection {
    var items: [Item]
}

extension HomeSection: SectionModelType {
    
    typealias Item = HomeList
    init(original: HomeSection, items: [HomeSection.Item]) {
        self = original
        self.items = items
    }
}
