//
//  Global.swift
//  Httper
//
//  Created by Meng Li on 17/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Alamofire
@_exported import RxBinding

let DEBUG = false

// Server base url
let baseUrl = "https://httper.mushare.cn/"
//let baseUrl = "http://192.168.96.128:8080/"

let ipInfoUrl = "https://ipapi.co/json/"
let whoisUrl = "https://www.whois.com"

func createUrl(_ relative: String) -> String {
    let requestUrl = baseUrl + relative
    return requestUrl
}

func imageURL(_ source: String) -> URL? {
    return URL(string: createUrl(source))
}

extension DefaultsKeys {
    static let type = DefaultsKey<String?>("type")
    static let email = DefaultsKey<String?>("email")
    static let name = DefaultsKey<String?>("name")
    static let avatar = DefaultsKey<String?>("avatar")
    static let characters = DefaultsKey<[String]?>("characters")
    static let deviceToken = DefaultsKey<String?>("deviceToken")
    static let token = DefaultsKey<String?>("token")
    static let login = DefaultsKey<Bool?>("login")
    static let requestRevision = DefaultsKey<Int?>("requestRevision")
    static let projectRevision = DefaultsKey<Int?>("projectRevision")
    static let version = DefaultsKey<String?>("version")
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

extension UIColor {
    // Pretty colors
    open class var normal: UIColor {
        return UIColor(hex: 0xeeeeee)
    }
    
    open class var key: UIColor {
        return UIColor(hex: 0xff9999)
    }
    
    open class var value: UIColor {
        return UIColor(hex: 0x33ccff)
    }
    
    // Design colors
    open class var background: UIColor {
        return UIColor(hex: 0x30363b)
    }
    
    open class var navigation: UIColor {
        return UIColor(hex: 0x3d4143)
    }
    
    open class var tableLine: UIColor {
        return UIColor(hex: 0xbcbbc1)
    }
}

enum ErrorCode: Int {
    case badRequest = -99999
    case tokenError = 901
    case emailRegistered = 1011
    case emailNotExist = 1021
    case passwordWrong = 1022
    case sendResetPasswordMail = 1031
    case accessTokenInvalid = 1041
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

// App update method, revoked only when app is updated.
func appUpdate() {
    if Defaults[.version] == nil {
        Defaults[.version] = "1.0"
    }
    if Defaults[.version] == App.version {
        return
    }
    switch App.version {
    case "2.0":
        let dao = DaoManager.shared
        let sync = SyncManager.shared
        for request in dao.requestDao.findWithNilPorject() {
            sync.deleteRequest(request, completionHandler: nil)
        }
        if Defaults[.token] != nil {
            Defaults[.version] = App.version
        }
    default:
        break
    }
}
