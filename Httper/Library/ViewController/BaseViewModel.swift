//
//  BaseViewMode.swift
//  Rinrin
//
//  Created by Meng Li on 2018/10/30.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
import RxAlertViewable

class BaseViewModel: NSObject, Stepper {

    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    let alert = PublishSubject<RxAlert>()
    let loading = PublishSubject<Bool>()
    
    deinit {
        AppLog.debug("[DEINIT View Model] \(type(of: self))")
    }
    
}
