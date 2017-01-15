//
//  RegisterViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerSuccessImageView: UIImageView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
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
    
    // MARK: - UITextViewDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let offset = keyboardHeight - (self.view.frame.size.height - registerButton.frame.maxY)
        if offset > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.frame = CGRect(x: 0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true;
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
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("register_not_validate", comment: ""),
                      controller: self)
            return
        }
        if !isEmailAddress(emailTextField.text!) {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("email_invalidate", comment: ""),
                      controller: self)
            return
        }
        let parameters: Parameters = [
            "email": emailTextField.text!,
            "name": usernameTextField.text!,
            "password": passwordTextField.text!
        ]
        registerButton.isEnabled = false
        loadingActivityIndicatorView.startAnimating()
        Alamofire.request(createUrl("api/user/register"),
                          method: HTTPMethod.post,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseJSON { response in
                self.registerButton.isEnabled = true
                self.loadingActivityIndicatorView.stopAnimating()
                let res = InternetResponse(response)
                if res.statusOK() {
                    self.registered = true
                    self.emailTextField.isHidden = true
                    self.passwordTextField.isHidden = true
                    self.usernameTextField.isHidden = true
                    self.registerSuccessImageView.isHidden = false
                    self.registerButton.setTitle(NSLocalizedString("back_to_login", comment: ""), for: .normal)
                } else {
                    switch res.errorCode() {
                    case ErrorCode.emailRegistered.rawValue:
                        showAlert(title: NSLocalizedString("tip", comment: ""),
                                  content: NSLocalizedString("email_registered", comment: ""),
                                  controller: self)
                    default:
                        break
                    }
                }
                
        }
    }

}
