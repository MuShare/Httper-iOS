//
//  RequestData.swift
//  Httper
//
//  Created by Meng Li on 2018/10/04.
//  Copyright © 2018 limeng. All rights reserved.
//

import Alamofire

struct RequestData {
    
    var method: String
    var url: String
    var headers: HTTPHeaders
    var parameters: Parameters
    var body: String
    
    init(method: String, url: String, headers: [KeyValue], parameters: [KeyValue], body: String) {
        self.method = method
        self.url = url
        self.headers = [:]
        self.parameters = [:]
        self.body = body
        
        headers.forEach { self.headers[$0.key] = $0.value }
        parameters.forEach { self.parameters[$0.key] = $0.value }
    }
    
}
