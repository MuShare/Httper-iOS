//
//  WhoisViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/08/20.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift

class WhoisViewModel: BaseViewModel {
    
    var title: Observable<String> {
        return .just("Whois")
    }
    
    func search() {
        
    }
    
}
