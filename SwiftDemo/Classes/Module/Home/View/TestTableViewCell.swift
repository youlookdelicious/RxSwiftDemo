//
//  TestTableViewCell.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/13.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell, ReusableView {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
