//
//  BodyViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 limeng. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

class BodyViewModel {
    
    let body = BehaviorRelay<String>(value: "")
    
}

extension BodyViewModel: Stepper {
    
}
