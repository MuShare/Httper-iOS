//
//  ModifyNameViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/2/10.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift

class ModifyNameViewModel: BaseViewModel {
    
    var title: Observable<String> {
        .just("Modify Name")
    }
    
    func save() {
        
    }
    
}
