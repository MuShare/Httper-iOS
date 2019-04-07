//
//  BaseViewController.swift
//  Rinrin
//
//  Created by Meng Li on 2018/11/07.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxAlertViewable
import RxSwift
import RxCocoa

class BaseViewController<ViewModel: BaseViewModel>: CustomNavigationBarViewController {

    let disposeBag = DisposeBag()
    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        AppLog.debug("[DEINIT View Controller] \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.alert ~> rx.alert ~ disposeBag
        viewModel.loading ~> rx.nvActivityIndicatorAnimating ~ disposeBag

    }

}

extension BaseViewController: NVActivityIndicatorViewable {}

extension BaseViewController: RxAlertViewable {}

extension BaseViewController {
    
    func bind<T, O>(_ observable: Observable<T>, to observer: O) where O: ObserverType, O.E == T {
        observable.bind(to: observer).disposed(by: disposeBag)
    }
    
    func twoWayBind<T>(_ behaviorRelay: BehaviorRelay<T>, to property: ControlProperty<T>) {
        behaviorRelay.twoWayBind(to: property).disposed(by: disposeBag)
    }
    
}
