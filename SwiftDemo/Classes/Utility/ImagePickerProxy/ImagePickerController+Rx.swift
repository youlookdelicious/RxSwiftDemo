//
//  ImagePickerController+Rx.swift
//  SwiftDemo
//
//  Created by yMac on 2019/8/26.
//  Copyright © 2019 cs. All rights reserved.
//

import Foundation

//取消指定视图控制器函数
func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

extension Reactive where Base: UIImagePickerController {
    
    
    //MARK: 设置代理
    //代理委托
    public var pickerDelegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    
    //图片选择完毕代理方法的封装
    public var didFinishPickingMediaWithInfo: Observable<[String: AnyObject]> {
        return pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
        .map({ (a) in
            return try self.castOrThrow(NSDictionary.self, a[1]) as! [String : AnyObject]
        })
    }
    
    //图片取消选择代理方法的封装
    public var didCancel: Observable<()> {
        return pickerDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
    //转类型的函数（转换失败后，会发出Error）
    fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        return returnValue
    }
    
    
    //MARK: 用于创建并自动显示图片选择控制器的静态方法
    static func createWithParent(_ parent: UIViewController?,
                                 animated: Bool = true,
                                 configureImagePicker: @escaping(UIImagePickerController) throws -> () = { imagePicker in }) -> Observable<UIImagePickerController> {
        //返回可观察序列
        return Observable.create { [weak parent] observer -> Disposable in
            //初始化一个图片选择控制器
            let imagePicker = UIImagePickerController()
            //不管图片选择完毕还是取消选择，都会发出.completed事件
            let dismissDisposable = Observable.merge(imagePicker.rx.didFinishPickingMediaWithInfo.map{_ in ()},
                                                     imagePicker.rx.didCancel)
                .subscribe(onNext: { (_) in
                    observer.on(.completed)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            
            //设置图片选择控制器初始参数，参数不正确则发出.error事件
            do {
                try configureImagePicker(imagePicker)
            } catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            //判断parent是否存在，不存在则发出.completed事件
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            //弹出控制器，显示界面
            parent.present(imagePicker, animated: animated, completion: nil)
            //发出.next事件（携带的是控制器对象）
            observer.on(.next(imagePicker))
            
            //销毁时自动退出图片控制器
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
        }
    
}
