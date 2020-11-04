//
//  CommonTool.swift
//  Httper
//
//  Created by lidaye on 08/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//


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
