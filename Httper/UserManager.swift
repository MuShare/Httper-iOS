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

class UserManager {
    
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
            return Defaults[.type] ?? ""
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
    
    static let sharedInstance: UserManager = {
        let instance = UserManager()
        return instance
    }()
    
    init() {

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
                          method: HTTPMethod.post,
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
                        completion?(false, NSLocalizedString("email_registered", comment: ""))
                    default:
                        completion?(false, NSLocalizedString("error_unknown", comment: ""))
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
                    // Login success, save user information to NSUserDefaults.
                    self.email = email
                    self.token = result["token"].stringValue
                    self.name = result["name"].stringValue
                    self.login = true
                    completion?(true, nil)
                } else {
                    switch response.errorCode() {
                    case .emailNotExist:
                        completion?(false, NSLocalizedString("email_not_exist", comment: ""))
                    case .passwordWrong:
                        completion?(false, NSLocalizedString("password_wrong", comment: ""))
                    default:
                        completion?(false, NSLocalizedString("error_unknown", comment: ""))
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
                // Login success, save user information to NSUserDefaults.
                self.token = result["token"].stringValue
                self.name = result["name"].stringValue
                self.login = true
                
                completion?(true, nil)
            } else {
                switch response.errorCode() {
                case .accessTokenInvalid:
                    completion?(false, NSLocalizedString("facebook_oauth_error", comment: ""))
                default:
                    completion?(false, NSLocalizedString("error_unknown", comment: ""))
                }
            }
        })
    }
    
}
