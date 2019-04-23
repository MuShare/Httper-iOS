//
//  BaseChildViewModel.swift
//  Rinrin
//
//  Created by Meng Li on 2019/04/17.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxAlertViewable
import RxController

class BaseChildViewModel: RxChildViewModel {
    
    let alert = PublishSubject<RxAlert>()
    
}
