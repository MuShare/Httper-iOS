//
//  BaseViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/01/01.
//  Copyright © 2019 MuShare Group. All rights reserved.
//

import RxSwift
import RxFlow
import RxAlertViewable

class BaseViewModel: NSObject, Stepper {
    
    let disposeBag = DisposeBag()
    let alert = PublishSubject<RxAlert>()
    let loading = PublishSubject<Bool>()
    
    deinit {
        NSLog("[DEINIT View Model] %@", type(of: self).description())
    }
    
}
