//
//  RequestManager.swift
//  Httper
//
//  Created by Meng Li on 2018/10/06.
//  Copyright © 2018 limeng. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire

final class RequestManager {
    
    static let shared = RequestManager()

    func send(_ request: RequestData) -> Observable<(HTTPURLResponse, Data)> {
        RxAlamofire.request(
            request.httpMethod,
            request.url,
            parameters: request.parameters,
            encoding: (request.body == "") ? URLEncoding.default : request.body,
            headers: HTTPHeaders(request.headers.map { HTTPHeader(name: $0.key, value: $0.value) })
        ).responseData()
    }
    
}
