//
//  GeoLocationService
//  SwiftDemo
//
//  Created by yMac on 2019/8/22.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation
import CoreLocation

//地理定位服务层
class GeoLocationService {
    //单例模式
    static let instance = GeoLocationService()
    
    //定位权限序列
    private (set) var authorized: Driver<Bool>
    
    //经纬度信息序列
    private (set) var location: Driver<CLLocationCoordinate2D>
    
    //定位管理器
    private let locationManager = CLLocationManager()
    
    private init() {
        
        //更新距离
        locationManager.distanceFilter = kCLDistanceFilterNone
        //设置定位精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //获取定位权限序列
        //deferred: 直到订阅发生的时候，才会创建序列，起到一个延迟创建的作用
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
        }
        .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
        .map {
            switch $0 {
            case .authorizedAlways:
                return true
            default:
                return false
            }
        }
        
        //获取经纬度信息序列
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        
        
        //发送授权申请
        locationManager.requestAlwaysAuthorization()
        //允许使用定位服务的话，开启定位服务更新
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}
