//
//  CommonTool.swift
//  Httper
//
//  Created by lidaye on 08/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit

func ClassByName(name : String) ->  AnyClass? {
    
    var result : AnyClass? = nil
    if let bundle = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
        let className = bundle + "." + name
        result = NSClassFromString(className)
    }
    return result
}

// MARK: - JSON String
func JSONStringWithObject(_ object: Any) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: object, options: .init(rawValue: 0))
        return String.init(data: jsonData, encoding: .utf8)
    } catch {
        print(error.localizedDescription)
        return nil
    }
}

//Transfer JSON string to dictionary
func serializeJSON(_ string: String) -> [String: Any]? {
    if let data = string.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

// MARK: - Validation
func isEmailAddress(_ testStr:String) -> Bool {
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}
