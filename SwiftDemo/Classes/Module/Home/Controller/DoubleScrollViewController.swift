//
//  DoubleScrollViewController.swift
//  SwiftDemo
//
//  Created by yMac on 2019/6/18.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit


class DoubleScrollViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var headerView: UIView!
    
    let disposeBag = DisposeBag()
    
    deinit {
        print("\(self.description) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取地理定位服务
        let geoLocationService = GeoLocationService.instance
        
        geoLocationService.location.drive(onNext: { (coordinate) in
            print(coordinate.latitude)
            geoLocationService.stopUpdatingLocation()
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        geoLocationService.authorized.drive(onNext: { (authorized) in

        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in

            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self?.tableView.mj_header.endRefreshing()
            })
        })
        
        headerView = UIView.init(frame: .init(x: 0, y: -200, width: kScreenWidth, height: 200))
        headerView.backgroundColor = .red
        tableView.addSubview(headerView)
        
        tableView.contentInset = .init(top: 200, left: 0, bottom: 0, right: 0)
        
    }


}


extension DoubleScrollViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var y: CGFloat = -200.0
        if offset < -200 {
            y = offset
        } else {
            y = -200.0
        }
        var frame = headerView.frame
        frame.origin.y = y
        headerView.frame = frame
    }
    
}
