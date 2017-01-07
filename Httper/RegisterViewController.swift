//
//  RegisterViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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

    // MARK: - Action
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func register(_ sender: Any) {
        if emailTextField.text == "" || usernameTextField.text == "" || passwordTextField.text == "" {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("register_not_validate", comment: ""),
                      controller: self)
        }
        let parameters: Parameters = [
            "email": emailTextField.text!,
            "name": usernameTextField.text!,
            "password": passwordTextField.text!
        ]
        Alamofire.request(createUrl("api/user/register"),
                          method: HTTPMethod.post,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseJSON { response in
                let res = InternetResponse(response)
                if res.statusOK() {
                    
                }
        }
    }
}
