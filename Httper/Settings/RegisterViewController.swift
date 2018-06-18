//
//  RegisterViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RegisterViewController: EditingViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerSuccessImageView: UIImageView!
    
    let user = UserManager.sharedInstance
    var registered = false

    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //Set background image
        let backgroundImageView: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            let ratio = view.frame.size.height / view.frame.size.width
            view.image = UIImage(named: ratio == 4 / 3 ? "register-bg-iPad.jpg" : "register-bg.jpg")
            return view
        }()
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        self.shownHeight = registerButton.frame.minY
    }
    
    // MARK: - Action
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func register(_ sender: Any) {
        if registered {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        if emailTextField.text == "" || usernameTextField.text == "" || passwordTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.register_not_validate())
            return
        }
        if !isEmailAddress(emailTextField.text!) {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.email_invalidate())
            return
        }
        
        finishEdit()
        startAnimating()
        user.register(email: emailTextField.text!,
                      name: usernameTextField.text!,
                      password: passwordTextField.text!)
        { (success, tip) in
            self.stopAnimating()
            if success {
                self.registered = true
                self.emailTextField.isHidden = true
                self.passwordTextField.isHidden = true
                self.usernameTextField.isHidden = true
                self.registerSuccessImageView.isHidden = false
                self.registerButton.setTitle(R.string.localizable.back_to_login(), for: .normal)
            } else {
                self.showAlert(title: R.string.localizable.tip_name(), content: tip!)
            }
        }
    }

}
