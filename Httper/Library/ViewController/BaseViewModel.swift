//
//  BaseViewMode.swift
//  Rinrin
//
//  Created by Meng Li on 2018/10/30.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxAlertViewable
import RxController

class BaseViewModel: RxViewModel {
    
    let alert = PublishSubject<RxAlert>()
    let actionSheet = PublishSubject<RxActionSheet>()
    let loading = PublishSubject<Bool>()
    
}
