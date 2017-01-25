//
//  Global.swift
//  Httper
//
//  Created by 李大爷的电脑 on 17/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire

// Server base url
//let baseUrl = "http://httper.fczm.pw/"
let baseUrl = "http://192.168.96.128:8080/"

let ipInfoUrl = "https://ipapi.co/json/"

extension DefaultsKeys {
    static let email = DefaultsKey<String?>("email")
    static let name = DefaultsKey<String?>("name")
    static let deviceToken = DefaultsKey<String?>("deviceToken")
    static let token = DefaultsKey<String?>("token")
    static let login = DefaultsKey<Bool?>("login")
    static let requestRevision = DefaultsKey<Int?>("requestRevision")
}

// JSON style
enum Style: Int {
    case pretty = 0
    case raw = 1
    case preview = 2
}

// Pretty color
enum PrettyColor: Int {
    case normal = 0xEEEEEE
    case key = 0xFF9999
    case value = 0x33CCFF
}

enum ErrorCode: Int {
    case badRequest = -99999
    case tokenError = 901
    case emailRegistered = 1011
    case emailNotExist = 1021
    case passwordWrong = 1022
    case addRequest = 2011
}

func tokenHeader() -> HTTPHeaders? {
    let token = Defaults[.token]
    if token == nil {
        return nil;
    }
    let headers: HTTPHeaders = [
        "token": token!
    ]
    return headers
}

func updateRequestRevision(_ revision: Int) {
    Defaults[.requestRevision] = revision
}

func requestRevision() -> Int {
    let requestRevision = Defaults[.requestRevision]
    if requestRevision == nil {
        return 0
    }
    return requestRevision!
}
