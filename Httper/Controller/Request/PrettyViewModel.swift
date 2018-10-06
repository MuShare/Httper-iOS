//
//  PrettyViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxFlow
import MGFormatter

class PrettyViewModel {
    
    let style = PublishSubject<FormatterStyle>()
    let text = PublishSubject<String>()
    
    func setText(string: String, headers: [AnyHashable : Any]) {
        guard let contentType = headers["Content-Type"] as? String else {
            return
        }
        if contentType.contains("text/html") {
            style.onNext(.htmlDark)
        } else if contentType.contains("application/json") {
            style.onNext(.jsonDark)
        } else {
            style.onNext(.noneDark)
        }
        text.onNext(string)
    }
    
}

extension PrettyViewModel: Stepper {
    
}
