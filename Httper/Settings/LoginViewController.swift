//
//  LoginViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import NVActivityIndicatorView

class LoginViewController: EditingViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let sync = SyncManager.sharedInstance
    let user = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //Set background image
        let backgroundImageView: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            let ratio = view.frame.size.height / view.frame.size.width
            view.image = UIImage(named: ratio == 4 / 3 ? "login-bg-iPad.jpg" : "login-bg.jpg")
            return view
        }()
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        self.shownHeight = loginButton.frame.minY
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
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.login_not_validate())
            return
        }

        finishEdit()
        startAnimating()
        
        user.loginWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (success, tip) in
            self.stopAnimating()
            if success {
                // Sync project and request entities from server
                self.sync.syncAll()
    
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(title: R.string.localizable.tip_name(), content: tip!)
            }
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile ], viewController: self) { loginResult in
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
                self.startAnimating()
                
                self.user.loginWithFacebook(accessToken.authenticationToken, completion: { (success, tip) in
                    self.stopAnimating()
                    if success {
                        // Sync project and request entities from server
                        self.sync.syncAll()
                        
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.showAlert(title: R.string.localizable.tip_name(), content: tip!)
                    }
                })
            }
        }
    }
    
}
