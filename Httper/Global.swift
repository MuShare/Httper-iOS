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

let DEBUG = true

// Server base url
//let baseUrl = "http://httper.mushare.cn/"
let baseUrl = "http://127.0.0.1:8080/"

let ipInfoUrl = "https://ipapi.co/json/"
let whoisUrl = "https://www.whois.com"

extension DefaultsKeys {
    static let email = DefaultsKey<String?>("email")
    static let name = DefaultsKey<String?>("name")
    static let deviceToken = DefaultsKey<String?>("deviceToken")
    static let token = DefaultsKey<String?>("token")
    static let login = DefaultsKey<Bool?>("login")
    static let requestRevision = DefaultsKey<Int?>("requestRevision")
    static let projectRevision = DefaultsKey<Int?>("projectRevision")
}

// JSON style
enum Style: Int {
    case pretty = 0
    case raw = 1
    case preview = 2
}

// Pretty color
enum PrettyColor: Int {
    case normal = 0xeeeeee
    case key = 0xff9999
    case value = 0x33ccff
}

enum DesignColor: Int {
    case background = 0x30363b
    case nagivation = 0x3d4143
    case tableLine = 0xbcbbc1
}

enum ErrorCode: Int {
    case badRequest = -99999
    case tokenError = 901
    case emailRegistered = 1011
    case emailNotExist = 1021
    case passwordWrong = 1022
    case sendResetPasswordMail = 1031
    case deleteRequest = 2011
    case deleteProject = 3011
}

func token() -> String? {
    return Defaults[.token]
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

func updateProjectRevision(_ revision: Int) {
    Defaults[.projectRevision] = revision
}

func projectRevision() -> Int {
    let projectRevision = Defaults[.projectRevision]
    if projectRevision == nil {
        return 0
    }
    return projectRevision!
}

func clearUserDefaults() {
    Defaults[.email] = nil
    Defaults[.name] = nil
    Defaults[.token] = nil
    Defaults[.login] = false
    Defaults[.requestRevision] = 0
}
