//
//  PreviewViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/05.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift

class PreviewViewModel: BaseViewModel {
    
    let content = BehaviorSubject<(String, URL?)>(value: ("", nil))
    
    func set(url: URL?, text: String) {
        content.onNext((text, url))
    }
    
}
