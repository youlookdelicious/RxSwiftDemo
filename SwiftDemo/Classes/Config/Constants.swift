//
//  Constants.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/9.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit


@_exported import RxDataSources
@_exported import RxSwift
@_exported import RxCocoa

@_exported import Moya
@_exported import HandyJSON
@_exported import SnapKit


// 屏幕相关
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
// 导航栏高度
let kNaviBarHeight : CGFloat = isFullScreen ? 88.0 : 64.0
/// 判断全面屏
var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
    }
    return false
}



// 颜色相关
func kHexColorA(_ HexString: String,_ a: CGFloat) ->UIColor {
    return UIColor.hex(hexString: HexString, alpha: a)
}

func kHexColor(_ HexString: String) ->UIColor {
    return UIColor.hex(hexString: HexString)
}


let KColorTabBarText = kHexColor("f55a5d")   //tab字体颜色
let kColorGrayF7F7F7 = kHexColor("F7F7F7")   //浅灰背景色

let THEME_WHITE_TINT = UIColor.black            //返回键颜色
let THEME_WHITE_BAR_TINT = UIColor.white        //nav背景色
let THEME_WHITE_BAR_TEXT = kHexColor("111111")  //nav字体颜色

let THEME_BLACK_TINT = UIColor.white
let THEME_BLACK_BAR_TINT = UIColor.black
let THEME_BLACK_BAR_TEXT = UIColor.white

