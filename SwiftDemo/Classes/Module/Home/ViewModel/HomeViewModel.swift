//
//  HomeViewModel.swift
//  SwiftDemo
//
//  Created by yMac on 2019/5/14.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation



class HomeViewModel {
    
    // 存放着解析完成的模型数组
    let models = BehaviorRelay<[HomeList]>(value: [])
    // 记录当前的索引值
    var index: Int = 1
    
    let bag = DisposeBag()
    
}


extension HomeViewModel: InOutTransform {
    
    
    typealias Input = HomeInput
    typealias Output = HomeOutput
    
    struct HomeInput {
        
        // 设置网络请求类型
        let category: HomeApi.HomeNetworkCategory
        init(category: HomeApi.HomeNetworkCategory) {
            self.category = category
        }
    }
    
    struct HomeOutput: OutputRefreshProtocol {
        
        // tableView的sections数据
        let sections: Driver<[HomeSection]>
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommond = PublishSubject<Bool>()
        // 告诉外界的tableView当前的刷新状态
        var refreshStatus: BehaviorRelay<RefreshStatus>
        
        init(sections: Driver<[HomeSection]>) {
            self.sections = sections
            /// 设置默认的刷新状态
            refreshStatus = BehaviorRelay<RefreshStatus>(value: .none)
        }
    }
    
    // 将input转换成output
    func transform(input: HomeViewModel.HomeInput) -> HomeViewModel.HomeOutput {
        let sections = models.asObservable().map { (models) -> [HomeSection] in
            return [HomeSection(items: models)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = HomeOutput(sections: sections)
        
        output.requestCommond.subscribe(onNext: { [unowned self] (isReloadData) in
            
            self.index = isReloadData ? 1 : self.index + 1
            homeProvider.rx.request(.homeList(type: input.category, size: 1, index: self.index))
                .asObservable()
                .cd_deserialize(HomeModel.self)
                .subscribe({ [weak self] (event) in
                    switch event {
                    case let .next(element):
                        self?.models.accept(isReloadData ? element.results ?? [] : (self?.models.value ?? []) + (element.results ?? []))
                        SVProgressHUD.showInfo(withStatus: "加载成功")
                    case let .error(error):
                        SVProgressHUD.showError(withStatus: error.localizedDescription)
                        output.refreshStatus.accept(isReloadData ? .endHeaderRefresh : .endFooterRefresh)
                    case .completed:
                        output.refreshStatus.accept(isReloadData ? .endHeaderRefresh : .endFooterRefresh)
                    }
                }).disposed(by: self.bag)
            
            }, onError: { (error) in
                
        },
               onCompleted: nil,
               onDisposed: nil).disposed(by: bag)
        
        return output
    }
    
}

