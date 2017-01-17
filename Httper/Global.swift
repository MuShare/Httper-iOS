//
//  Global.swift
//  Httper
//
//  Created by 李大爷的电脑 on 17/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

// Server base url
let baseUrl = "http://httper.fczm.pw/"
let ipInfoUrl = "https://ipapi.co/json/"

extension DefaultsKeys {
    static let email = DefaultsKey<String?>("email")
    static let name = DefaultsKey<String?>("name")
    static let deviceToken = DefaultsKey<String?>("deviceToken")
    static let token = DefaultsKey<String?>("token")
    static let login = DefaultsKey<Bool?>("login")
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
    case emailRegistered = 1011
    case emailNotExist = 1021
    case passwordWrong = 1022
}
