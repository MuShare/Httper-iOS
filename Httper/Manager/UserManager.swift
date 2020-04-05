//
//  UserManager.swift
//  Httper
//
//  Created by Meng Li on 19/05/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import Alamofire
import RxCocoa
import SwiftyUserDefaults

enum UserType: String {
    case email = "email"
    case facebook = "facebook"
}

final class UserManager {
    
    var dao: DaoManager!
    
    var login: Bool {
        set {
            Defaults.login = newValue
        }
        get {
            return Defaults.login ?? false
        }
    }
    
    var token: String {
        set {
            Defaults.token = newValue
        }
        get {
            return Defaults.token ?? ""
        }
    }
    
    var type: UserType {
        set {
            Defaults.type = newValue.rawValue
        }
        get {
            return UserType(rawValue: Defaults.type ?? UserType.email.rawValue) ?? .email
        }
    }
    
    var email: String {
        set {
            Defaults.email = newValue
        }
        get {
            return Defaults.email ?? ""
        }
    }
    
    var name: String {
        set {
            Defaults.name = newValue
        }
        get {
            return Defaults.name ?? ""
        }
    }
    
    var avatar: String {
        set {
            Defaults.avatar = newValue
        }
        get {
            return Defaults.avatar ?? ""
        }
    }
    
    var avatarURL: URL? {
        get {
            return login ? URL(string: createUrl(avatar)) : nil
        }
    }
    
    var characters: [String]? {
        set {
            guard let newValue = newValue else {
                return
            }
            Defaults.characters = newValue
            charactersRelay.accept(newValue)
        }
        get {
            var characters = Defaults.characters
            if characters == nil {
                characters = [":", "/", "?", "&", ".", "=", "%", "[", "]", "{", "}"]
                Defaults.characters = characters
            }
            return characters
        }
    }
    
    var displayEmail: String {
        switch type {
        case .email:
            return email
        case .facebook:
            return R.string.localizable.sign_in_facebook()
        }
    }
    
    // Once characters is updated, the keyboard accessory should be updated.
    var charactersRelay = BehaviorRelay<[String]>(value: [])
    
    static let shared = UserManager()
    
    init() {
        dao = DaoManager.shared
        charactersRelay.accept(characters ?? [])
    }
    
    func pullUser(_ completionHandler: ((Bool) -> Void)? = nil) {
        Alamofire.request(
            createUrl("api/user"),
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        )
            .responseJSON { [weak self] in
                guard let `self` = self else {
                    return
                }
                let response = InternetResponse($0)
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

        Alamofire.request(
            createUrl("api/user/register"),
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: nil
        ).responseJSON {
            let response = InternetResponse($0)
            if response.statusOK() {
                completion?(true, nil)
            } else {
                switch response.errorCode() {
                case .emailRegistered:
                    completion?(false, R.string.localizable.user_email_registered())
                default:
                    completion?(false, R.string.localizable.common_error_unknown())
                }
            }
        }
    }
    
    func loginWithEmail(email: String, password: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "email": email,
            "password": password,
            "deviceIdentifier": UIDevice.current.identifierForVendor!.uuidString,
            "deviceToken": Defaults.deviceToken ?? "",
            "os": "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)",
            "lan": NSLocale.preferredLanguages[0]
        ]
        
        Alamofire.request(
            createUrl("api/user/login"),
            method: .post,
            parameters: params,
            encoding: URLEncoding.default,
            headers: nil
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = InternetResponse($0)
            if response.statusOK() {
                let result = response.getResult()
                let user = result["user"]
                // Login success, save user information to NSUserDefaults.
                self.email = email
                self.token = result["token"].stringValue
                self.name = user["name"].stringValue
                self.avatar = user["avatar"].stringValue
                self.type = .email
                self.login = true
                completion?(true, nil)
            } else {
                switch response.errorCode() {
                case .emailNotExist:
                    completion?(false, R.string.localizable.user_email_not_exist())
                case .passwordWrong:
                    completion?(false, R.string.localizable.user_password_wrong())
                default:
                    completion?(false, R.string.localizable.common_error_unknown())
                }
            }
        }
    }
    
    func loginWithFacebook(_ token: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "accessToken": token,
            "deviceIdentifier": UIDevice.current.identifierForVendor!.uuidString,
            "deviceToken": Defaults.deviceToken ?? "",
            "os": "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)",
            "lan": NSLocale.preferredLanguages[0]
        ]
        
        Alamofire.request(
            createUrl("/api/user/fblogin"),
            method: .post,
            parameters: params,
            encoding: URLEncoding.default,
            headers: nil
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = InternetResponse($0)
            if response.statusOK() {
                let result = response.getResult()
                let user = result["user"]
                // Login success, save user information to NSUserDefaults.
                self.token = result["token"].stringValue
                self.name = user["name"].stringValue
                self.avatar = user["avatar"].stringValue
                self.type = .facebook
                self.login = true
                
                completion?(true, nil)
            } else {
                switch response.errorCode() {
                case .accessTokenInvalid:
                    completion?(false, R.string.localizable.user_facebook_oauth_error())
                default:
                    completion?(false, R.string.localizable.common_error_unknown())
                }
            }
        }
    }
    
    func reset(_ email: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "email": email
        ]

        Alamofire.request(
            createUrl("api/user/password/reset"),
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON {
            let response = InternetResponse($0)
            if response.statusOK() {
                completion?(true, nil)
            } else {
                switch response.errorCode() {
                case .emailNotExist:
                    completion?(false, R.string.localizable.user_email_not_exist())
                case .sendResetPasswordMail:
                    completion?(false, R.string.localizable.reset_password_failed())
                default:
                    completion?(false, R.string.localizable.common_error_unknown())
                }
            }
        }
    }
    
    func modifyName(_ name: String, completion: ((Bool, String?) -> Void)?) {
        let params: Parameters = [
            "name": name
        ]

        Alamofire.request(
            createUrl("api/user/name"),
            method: .post,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = InternetResponse($0)
            if response.statusOK() {
                self.name = name
                completion?(true, nil)
            } else {
                switch response.errorCode() {
                case .tokenError:
                    completion?(false, R.string.localizable.common_token_error())
                default:
                    completion?(false, R.string.localizable.common_error_unknown())
                }
            }
        }
    }
    
    func logout() {
        type = .email
        email = ""
        name = ""
        avatar = ""
        token = ""
        login = false
        Defaults.requestRevision = 0
        
        // Reset revision to 0 for those request entities whose revision is larger than 0.
        for request in dao.requestDao.findRevisionLargerThan(0) {
            request.revision = 0
        }
        dao.saveContext()
    }
    
}
