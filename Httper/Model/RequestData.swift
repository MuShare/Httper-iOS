//
//  RequestData.swift
//  Httper
//
//  Created by Meng Li on 2018/10/04.
//  Copyright © 2018 MuShare. All rights reserved.
//

import Alamofire

struct RequestData {
    
    var method: String
    var url: String
    var headers: StorageHttpHeaders
    var parameters: Parameters
    var body: String
    
    init(method: String, url: String, headers: [KeyValue], parameters: [KeyValue], body: String) {
        self.method = method
        self.url = url
        self.headers = headers.filter { $0.isNotEmpty }.reduce([:]) {
            var dict = $0
            dict[$1.key] = $1.value
            return dict
        }
        self.parameters = parameters.filter { $0.isNotEmpty }.reduce([:]) {
            var dict = $0
            if var value = dict[$1.key] as? [String] {
                value.append($1.value)
                dict[$1.key] = value
            } else if let value = dict[$1.key] as? String {
                dict[$1.key] = [value, $1.value]
            } else {
                dict[$1.key] = $1.value
            }
            return dict
        }
        self.body = body
    }
    
}

extension RequestData {
    
    var httpMethod: HTTPMethod {
        switch method {
        case "GET":     return .get
        case "HEAD":    return .head
        case "POST":    return .post
        case "PUT":     return .put
        case "DELETE":  return .delete
        case "CONNECT": return .connect
        case "OPTIONS": return .options
        case "TRACE":   return .trace
        case "PATCH":   return .patch
        default:        return .get
        }
    }
    
    var bodyData: NSData? {
        guard let data = body.data(using: .utf8) else {
            return nil
        }
        return NSData(data: data)
    }
    
}
