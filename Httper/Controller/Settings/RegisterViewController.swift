//
//  RegisterViewController.swift
//  Httper
//
//  Created by Meng Li on 04/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RegisterViewController: EditingViewController, NVActivityIndicatorViewable {

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = R.image.loginBgJpg()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerSuccessImageView: UIImageView!
    
    let user = UserManager.shared
    var registered = false

    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        view.insertSubview(backgroundImageView, at: 0)
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
        if let email = emailTextField.text, !email.isEmailAddress {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.email_invalidate())
            return
        }
        
        finishEdit()
        startAnimating()
        user.register(email: emailTextField.text!,
                      name: usernameTextField.text!,
                      password: passwordTextField.text!)
        { [weak self] (success, tip) in
            guard let `self` = self else { return }
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
