//
//  LoginViewController.swift
//  Httper
//
//  Created by Meng Li on 04/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import NVActivityIndicatorView

class LoginViewController: EditingViewController, NVActivityIndicatorViewable {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = R.image.loginBgJpg()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let sync = SyncManager.shared
    let user = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        self.shownHeight = loginButton.frame.minY
    }
    
    // MARK: - Action
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func login(_ sender: Any) {
        if emailTextField.text == "" || !(emailTextField.text!).isEmailAddress || passwordTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.login_not_validate())
            return
        }

        finishEdit()
        startAnimating()
        
        user.loginWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] (success, tip) in
            guard let `self` = self else { return }
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
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { loginResult in
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
                
                self.user.loginWithFacebook(accessToken.tokenString) { [weak self] (success, tip) in
                    guard let `self` = self else { return }
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
        }
    }
    
}
