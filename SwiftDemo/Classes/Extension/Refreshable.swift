//
//  Refreshable.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/17.
//  Copyright © 2019 cs. All rights reserved.
//


// ------------------- 

import Foundation


protocol Refreshable {
    
}

extension Refreshable where Self: UIViewController {
    func initRefreshHeader(_ scrollView: UIScrollView, _ action: @escaping () -> Void) -> MJRefreshHeader {
        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { action() })
        return scrollView.mj_header
    }
    
    func initRefreshFooter(_ scrollView: UIScrollView, _ action: @escaping () -> Void) -> MJRefreshFooter {
        scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { action() })
        return scrollView.mj_footer
    }
}


protocol OutputRefreshProtocol {
    
    var refreshStatus: BehaviorRelay<RefreshStatus> {get}
}


extension OutputRefreshProtocol {
    
    func autoSetRefreshStatus(header: MJRefreshHeader?, footer: MJRefreshFooter?) -> Disposable {
        return refreshStatus.asObservable().subscribe(onNext: { (status) in
            switch status {
            case .beingHeaderRefresh:
                header?.beginRefreshing()
            case .endHeaderRefresh:
                header?.endRefreshing()
            case .beingFooterRefresh:
                footer?.beginRefreshing()
            case .endFooterRefresh:
                footer?.endRefreshing()
            case .noMoreData:
                footer?.endRefreshingWithNoMoreData()
            default:
                break
            }
        })
    }
}
