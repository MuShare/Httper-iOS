//
//  RawViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/05.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift

class RawViewModel: BaseViewModel {
    
    let text = PublishSubject<String>()
    
    func set(text: String) {
        self.text.onNext(text)
    }
    
}
