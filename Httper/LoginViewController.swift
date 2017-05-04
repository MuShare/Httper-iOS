//
//  LoginViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults
import FacebookCore
import FacebookLogin

class LoginViewController: EditingViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    let sync = SyncManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fbLoginButton = LoginButton(readPermissions: [.publicProfile])
        fbLoginButton.center = view.center
        
        view.addSubview(loginButton)
        
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        self.shownHeight = loginButton.frame.maxY
        
        //Set background image
        let backgroundImageView: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            let ratio = view.frame.size.height / view.frame.size.width
            view.image = UIImage(named: ratio == 4 / 3 ? "login-bg-iPad.jpg" : "login-bg.jpg")
            return view
        }()
        self.view.insertSubview(backgroundImageView, at: 0)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Action
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func login(_ sender: Any) {
        if emailTextField.text == "" || !isEmailAddress(emailTextField.text!) || passwordTextField.text == "" {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("login_not_validate", comment: ""),
                      controller: self)
            return
        }

        loginButton.isEnabled = false
        loadingActivityIndicatorView.startAnimating()
        
        let params: Parameters = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
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
            self.loginButton.isEnabled = true
            self.loadingActivityIndicatorView.stopAnimating()
            
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let result = response.getResult()
                // Login success, save user information to NSUserDefaults.
                Defaults[.email] = self.emailTextField.text
                Defaults[.token] = result?["token"] as? String
                Defaults[.name] = result?["name"] as? String
                Defaults[.login] = true
                
                // Sync project and request entities from server
                self.sync.syncAll()
                
                self.dismiss(animated: true, completion: nil)
            } else {
                switch response.errorCode() {
                case ErrorCode.emailNotExist.rawValue:
                    showAlert(title: NSLocalizedString("tip_name", comment: ""),
                              content: NSLocalizedString("email_not_exist", comment: ""),
                              controller: self)
                case ErrorCode.passwordWrong.rawValue:
                    showAlert(title: NSLocalizedString("tip_name", comment: ""),
                              content: NSLocalizedString("password_wrong", comment: ""),
                              controller: self)
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                if DEBUG {
                    print("Facebook OAuth login error: \(error)");
                }
            case .cancelled:
                if DEBUG {
                    print("User cancelled login.");
                }
            case .success(_, _, let accessToken):
                print(accessToken.authenticationToken)
                
                let params: Parameters = [
                    "accessToken":accessToken.authenticationToken,
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
                        Defaults[.token] = result?["token"] as? String
                        Defaults[.name] = result?["name"] as? String
                        Defaults[.login] = true
                        
                        // Sync project and request entities from server
                        self.sync.syncAll()
                        
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        switch response.errorCode() {
                        case ErrorCode.accessTokenInvalid.rawValue:
                            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                                      content: NSLocalizedString("facebook_oauth_error", comment: ""),
                                      controller: self)
                        default:
                            break
                        }
                    }

                })
            }
        }
    }
    
}
