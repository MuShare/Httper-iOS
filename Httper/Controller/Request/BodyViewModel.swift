//
//  BodyViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

class BodyViewModel: BaseViewModel {
    
    let body = BehaviorRelay<String?>(value: nil)
    
    var characters: Observable<[String]> {
        UserManager.shared.charactersRelay.asObservable()
    }
    
    func clear() {
        body.accept(nil)
    }
    
}
