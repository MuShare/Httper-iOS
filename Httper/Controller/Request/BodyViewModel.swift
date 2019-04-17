//
//  BodyViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 limeng. All rights reserved.
//

import RxSwift
import RxCocoa

class BodyViewModel: BaseViewModel {
    
    let body = BehaviorRelay<String?>(value: nil)
    
}
