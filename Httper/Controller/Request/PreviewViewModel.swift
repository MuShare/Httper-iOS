//
//  PreviewViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/05.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxFlow

class PreviewViewModel {
    
    let url = PublishSubject<URL?>()
    let text = PublishSubject<String>()
    
    func set(text: String, url: URL?) {
        self.text.onNext(text)
        self.url.onNext(url)
    }
    
}

extension PreviewViewModel: Stepper {
    
}
