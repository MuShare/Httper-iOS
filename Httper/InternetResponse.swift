//
//  InternetResponse.swift
//  Httper
//
//  Created by 李大爷的电脑 on 07/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Alamofire

enum ErrorCode: Int {
    case emailRegistered = 1011
}

let baseUrl = "http://httper.fczm.pw/"
//let baseUrl = "http://127.0.0.1:8080/"

func createUrl(_ relative: String) -> String {
    let requestUrl = baseUrl + relative
    return requestUrl
}

class InternetResponse: NSObject {
    
    var data: [String: Any]!
    
    init(_ response: DataResponse<Any>) {
        data = response.result.value as! Dictionary<String, Any>!
        print("Reponse status: \(response.response!)")
        print("Response with JSON: \(data!)")
    }
    
    func statusOK() -> Bool {
        return data["status"] as! Int == 200
    }
    
    func getResult() -> [String: Any]! {
        return data["result"] as! [String: Any]
    }
    
    func errorCode() -> Int {
        return data["error_code"] as! Int
    }
    
}
