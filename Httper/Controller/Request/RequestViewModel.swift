//
//  RequestViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxSwift
import RxFlow
import MGSelector

fileprivate struct Const {
    static let methods = ["GET", "POST", "HEAD", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
}

struct DetailOption {
    var key: String
}

extension DetailOption: MGSelectorOption {
    
    var title: String {
        return key
    }
    
    var detail: String? {
        return NSLocalizedString(key, comment: "")
    }
    
}

class RequestViewModel {
    
    let requestMethods = Const.methods.map { DetailOption(key: $0) }
    
}

extension RequestViewModel: Stepper {
    
}
