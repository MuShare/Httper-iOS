//
//  UserManager.swift
//  Httper
//
//  Created by 李大爷的电脑 on 19/05/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

let UserTypeEmail = "email"
let UserTypeFacebook = "facebook"

class UserManager {
    
    var dao: DaoManager!
    
    var login: Bool {
        set {
            Defaults[.login] = newValue
        }
        get {
            return Defaults[.login] ?? false
        }
    }
    
    var token: String {
        set {
            Defaults[.token] = newValue
        }
        get {
            return Defaults[.token] ?? ""
        }
    }
    
    var type: String {
        set {
            Defaults[.type] = newValue
        }
        get {
            return Defaults[.type] ?? UserTypeEmail
        }
    }
    
    var email: String {
        set {
            Defaults[.email] = newValue
        }
        get {
            return Defaults[.email] ?? ""
        }
    }
    
    var name: String {
        set {
            Defaults[.name] = newValue
        }
        get {
            return Defaults[.name] ?? ""
        }
    }
    
    var avatar: String {
        set {
            Defaults[.avatar] = newValue
        }
        get {
            return Defaults[.avatar] ?? ""
        }
    }
    
    var avatarURL: URL? {
        get {
            return login ? URL(string: createUrl(avatar)) : nil
        }
    }
    
    var characters: [String]? {
        set {
            Defaults[.characters] = newValue
        }
        get {
            var characters = Defaults[.characters]
            if characters == nil {
                characters = [":", "/", "?", "&", ".", "=", "%", "[", "]", "{", "}"]
                Defaults[.characters] = characters
            }
            return characters
        }
    }
    
    static let shared = UserManager()
    
    init() {
        dao = DaoManager.shared
    }
    
    func pullUser(_ completionHandler: ((Bool) -> Void)?) {
        Alamofire.request(createUrl("api/user"),
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let user = response.getResult()["user"]
                self.name = user["name"].stringValue
                self.avatar = user["avatar"].stringValue
                completionHandler?(true)
            } else {
                completionHandler?(false)
            }
        }
    }
    
    func register(email: String, name: String, password: String, completion: ((Bool, String?) -> Void)?) {
        let parameters: Parameters = [
            "email": email,
            "name": name,
            "password": password
        ]

        Alamofire.request(createUrl("api/user/register"),
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseJSON { responseObject in

                let response = InternetResponse(responseObject)
                if response.statusOK() {
                    completion?(true, nil)
                } else {
                    switch response.errorCode() {
                    case .emailRegistered:
                        completion?(false, R.string.localizable.email_registered())
                    default:
                        completion?(false, R.string.localizable.error_unknown())
                    }
                }
        }

    }
    
    func loginWithEmail(email: String, password: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "email": email,
            "password": password,
            "deviceIdentifier": UIDevice.current.identifierForVendor!.uuidString,
            "deviceToken": Defaults[.deviceToken] == nil ? "" : Defaults[.deviceToken]!,
            "os": "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)",
            "lan": NSLocale.preferredLanguages[0]
        ]
        
        Alamofire.request(createUrl("api/user/login"),
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseJSON { (responseObject) in

                let response = InternetResponse(responseObject)
                if response.statusOK() {
                    let result = response.getResult()
                    let user = result["user"]
                    // Login success, save user information to NSUserDefaults.
                    self.email = email
                    self.token = result["token"].stringValue
                    self.name = user["name"].stringValue
                    self.avatar = user["avatar"].stringValue
                    self.type = UserTypeEmail
                    self.login = true
                    completion?(true, nil)
                } else {
                    switch response.errorCode() {
                    case .emailNotExist:
                        completion?(false, R.string.localizable.email_not_exist())
                    case .passwordWrong:
                        completion?(false, R.string.localizable.password_wrong())
                    default:
                        completion?(false, R.string.localizable.error_unknown())
                    }
                }
        }
    }
    
    func loginWithFacebook(_ token: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "accessToken": token,
            "deviceIdentifier": UIDevice.current.identifierForVendor!.uuidString,
            "deviceToken": Defaults[.deviceToken] == nil ? "" : Defaults[.deviceToken]!,
            "os": "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)",
            "lan": NSLocale.preferredLanguages[0]
        ]
        
        Alamofire.request(createUrl("/api/user/fblogin"),
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: nil)
        .responseJSON(completionHandler: { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let result = response.getResult()
                let user = result["user"]
                // Login success, save user information to NSUserDefaults.
                self.token = result["token"].stringValue
                self.name = user["name"].stringValue
                self.avatar = user["avatar"].stringValue
                self.type = UserTypeFacebook
                self.login = true
                
                completion?(true, nil)
            } else {
                switch response.errorCode() {
                case .accessTokenInvalid:
                    completion?(false, R.string.localizable.facebook_oauth_error())
                default:
                    completion?(false, R.string.localizable.error_unknown())
                }
            }
        })
    }
    
    func reset(_ email: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "email": email
        ]

        Alamofire.request(createUrl("api/user/password/reset"),
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
            .responseJSON { (responseObject) in
                let response = InternetResponse(responseObject)
                if response.statusOK() {
                    completion?(true, nil)
                } else {
                    switch response.errorCode() {
                    case .emailNotExist:
                        completion?(false, R.string.localizable.email_not_exist())
                    case .sendResetPasswordMail:
                        completion?(false, R.string.localizable.reset_password_failed())
                    default:
                        completion?(false, R.string.localizable.error_unknown())
                    }
                }
        }
    }
    
    func modifyName(_ name: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "name": name
        ]

        Alamofire.request(createUrl("api/user/name"),
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
            .responseJSON { (responseObject) in
                let response = InternetResponse(responseObject)
                if response.statusOK() {
                    self.name = name
                    completion?(true, nil)
                } else {
                    switch response.errorCode() {
                    case .tokenError:
                        completion?(false, R.string.localizable.token_error())
                    default:
                        completion?(false, R.string.localizable.error_unknown())
                    }
                }
        }
    }
    
    func logout() {
        self.type = ""
        self.email = ""
        self.name = ""
        self.avatar = ""
        self.token = ""
        self.login = false
        Defaults[.requestRevision] = 0
        
        // Reset revision to 0 for those request entities whose revision is larger than 0.
        for request in dao.requestDao.findRevisionLargerThan(0) {
            request.revision = 0
        }
        dao.saveContext()
    }
    
}
