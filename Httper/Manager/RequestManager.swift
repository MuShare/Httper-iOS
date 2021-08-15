//
//  RequestManager.swift
//  Httper
//
//  Created by Meng Li on 2018/10/06.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire

final class RequestManager {
    
    static let shared = RequestManager()

    func send(_ request: RequestData) -> Observable<(HTTPURLResponse, Data)> {
        var url = request.url
        var singleParameters: [String: Any] = [:]
        var isUrlParameterAppended = false
        request.parameters.forEach { key, value in
            if let values = value as? [String] {
                url += !isUrlParameterAppended ? "?" : "&"
                url += values.map { "\(key)=\($0)" }
                    .joined(separator: "&")
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                isUrlParameterAppended = true
            } else {
                singleParameters[key] = value
            }
        }
        return RxAlamofire
            .request(
                request.httpMethod,
                url,
                parameters: singleParameters,
                encoding: request.body.isEmpty ? URLEncoding.default : request.body,
                headers: HTTPHeaders(request.headers.map { HTTPHeader(name: $0.key, value: $0.value) })
            )
            .responseData()
    }
    
}
