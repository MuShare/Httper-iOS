//
//  ResultViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

class ResultViewModel {
    
    private let requestData: RequestData
    
    init(requestData: RequestData) {
        self.requestData = requestData
    }
    
}

extension ResultViewModel: Stepper {
    
}
