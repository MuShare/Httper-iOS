//
//  RequestViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
import MGSelector

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
    
    private let headersViewModel: KeyValueViewModel
    private let parametersViewModel: KeyValueViewModel
    private let bodyViewModel: BodyViewModel
    
    init(headersViewModel: KeyValueViewModel, parametersViewModel: KeyValueViewModel,  bodyViewModel: BodyViewModel) {
        self.headersViewModel = headersViewModel
        self.parametersViewModel = parametersViewModel
        self.bodyViewModel = bodyViewModel
    }
    
    let protocols = ["http", "https"]
    let methods = ["GET", "POST", "HEAD", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
    
    let requestMethod = BehaviorRelay<String>(value: "GET")
    let url = BehaviorRelay<String>(value: "")
    let requestProtocol = BehaviorRelay<Int>(value: 0)
    
}

extension RequestViewModel: Stepper {
    
    func sendRequest() {
        let requestData = RequestData(method: requestMethod.value,
                                      url: protocols[requestProtocol.value] + "://" + url.value,
                                      headers: Array(headersViewModel.results.values),
                                      parameters: Array(parametersViewModel.results.values),
                                      body: bodyViewModel.body.value)
        step.accept(RequestStep.result(requestData))
    }
    
}
