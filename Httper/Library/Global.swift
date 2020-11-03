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

func createUrl(_ relative: String) -> String {
    let baseUrl = UIApplication.shared.isProduction ?
        "https://httper.mushare.cn/" : "https://beta-httper.mushare.cn/"
    return baseUrl + relative
}

func imageURL(_ source: String) -> URL? {
    return URL(string: createUrl(source))
}

extension DefaultsKeys {
    var type: DefaultsKey<String?> { .init("type") }
    var email: DefaultsKey<String?> { .init("email") }
    var name: DefaultsKey<String?> { .init("name") }
    var avatar: DefaultsKey<String?> { .init("avatar") }
    var characters: DefaultsKey<[String]?> { .init("characters") }
    var deviceToken: DefaultsKey<String?> { .init("deviceToken") }
    var token: DefaultsKey<String?> { .init("token") }
    var login: DefaultsKey<Bool?> { .init("login") }
    var requestRevision: DefaultsKey<Int?> { .init("requestRevision") }
    var projectRevision: DefaultsKey<Int?> { .init("projectRevision") }
    var version: DefaultsKey<String?> { .init("version") }
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
    case navigation = 0x3d4143
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
    return Defaults.token
}

func tokenHeader() -> HTTPHeaders? {
    let token = Defaults.token
    if token == nil {
        return nil;
    }
    let headers: HTTPHeaders = [
        "token": token!
    ]
    return headers
}

func updateRequestRevision(_ revision: Int) {
    Defaults.requestRevision = revision
}

func requestRevision() -> Int {
    let requestRevision = Defaults.requestRevision
    if requestRevision == nil {
        return 0
    }
    return requestRevision!
}

func updateProjectRevision(_ revision: Int) {
    Defaults.projectRevision = revision
}

func projectRevision() -> Int {
    let projectRevision = Defaults.projectRevision
    if projectRevision == nil {
        return 0
    }
    return projectRevision!
}

// App update method, revoked only when app is updated.
func appUpdate() {
    if Defaults.version == nil {
        Defaults.version = "1.0"
    }
    if Defaults.version == App.version {
        return
    }
    switch App.version {
    case "2.0":
        let dao = DaoManager.shared
        let sync = SyncManager.shared
        for request in dao.requestDao.findWithNilProject() {
            sync.deleteRequest(request)
        }
        if Defaults.token != nil {
            Defaults.version = App.version
        }
    default:
        break
    }
}
