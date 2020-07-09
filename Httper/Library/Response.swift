//
//  InternetResponse.swift
//  Httper
//
//  Created by Meng Li on 07/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Response: NSObject {
    
    var data: [String: Any] = [:]
    
    init(_ response: AFDataResponse<Any>) {
        if DEBUG {
            NSLog("New response, status:\n\(response)")
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                NSLog("Response body: \n\(body)")
            }
        }
        if let value = response.value as? [String: Any] {
            data = value
        }
        if DEBUG {
            if !data.isEmpty {
                NSLog("Response with JSON:\n\(data)")
            }
        }
    }
    
    func statusOK() -> Bool {
        if data.isEmpty {
            return false
        }
        return data["status"] as! Int == 200
    }
    
    func getResult() -> JSON {
        return JSON(data["result"] as! [String: Any])
    }
    
    func errorCode() -> ErrorCode {
        if data.isEmpty {
            return .badRequest
        }
        let code = data["errorCode"] as! Int
        return ErrorCode(rawValue: code) ?? .badRequest
    }
    
}

