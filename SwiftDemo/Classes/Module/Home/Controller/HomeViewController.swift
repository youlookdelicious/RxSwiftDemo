//
//  HomeViewController.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/9.
//  Copyright © 2019 cs. All rights reserved.
//

import UIKit


class HomeViewController: BaseViewController {

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private lazy var bag = DisposeBag()
    private lazy var homeViewModel = HomeViewModel()
    
    let dataSource = RxTableViewSectionedReloadDataSource<HomeSection>(configureCell: {(datasource, tableView, indexPath, model) in
        let cell: TestTableViewCell = tableView.cm_dequeueReusableCell(forIndexPath: indexPath)
        cell.titleLabel.text = model.desc
        cell.subTitleLabel.text = model.source
        return cell
    })
    
    deinit {
        print("\(self.description) deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        bindView()
        
    }
    
    private func setupUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        
        tableView.cm_register(cell: TestTableViewCell.self)
        
    }
    
    
    
}

// MARK: - tableView delegate & dataSource
extension HomeViewController: UITableViewDelegate {
    
}


extension HomeViewController: Refreshable {
    
    private func bindView() {
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        let vmInput = HomeViewModel.HomeInput(category: .welfare)
        let vmOutput = homeViewModel.transform(input: vmInput)
        
        /**
         关于driver的介绍：
         https://www.jianshu.com/p/298914bf4562
         */
        /// 将数据绑定到表格
        vmOutput.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        /// 设置刷新状态
        let refreshHeader = initRefreshHeader(tableView) {
            vmOutput.requestCommond.onNext(true)
        }
        let refreshFooter = initRefreshFooter(tableView) {
            vmOutput.requestCommond.onNext(false)
        }
        vmOutput.autoSetRefreshStatus(header: refreshHeader, footer: refreshFooter).disposed(by: bag)
        
        tableView.mj_header.beginRefreshing()
    }
}
