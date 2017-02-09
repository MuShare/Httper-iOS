//
//  ResetViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 08/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import Alamofire

class ResetViewController: EditingViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var sendEmailSuccessImageView: UIImageView!
    @IBOutlet weak var tipTextView: UITextView!
    
    var submit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        self.shownHeight = submitButton.frame.maxY
        
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
    
    @IBAction func submit(_ sender: Any) {
        // If email is submitted before, back to sign in view
        if submit {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        if !isEmailAddress(emailTextField.text!) {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("reset_password_not_validate", comment: ""),
                      controller: self)
            return
        }
        let params: Parameters = [
            "email": emailTextField.text!
        ]
        self.finishEdit()
        // Disable submit button, start loading...
        submitButton.isEnabled = false
        loadingActivityIndicatorView.startAnimating()
        Alamofire.request(createUrl("api/user/password/reset"),
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            // Enable submit button, stop loading.
            self.submitButton.isEnabled = true
            self.loadingActivityIndicatorView.stopAnimating()
            
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                // Set submit flag to true
                self.submit = true
                // Hide tip and email text field
                self.tipTextView.isHidden = true
                self.emailTextField.isHidden = true
                // Show success image.
                self.sendEmailSuccessImageView.isHidden = false
                self.submitButton.setTitle(NSLocalizedString("back_to_login", comment: ""), for: .normal)
                self.titleLabel.text = NSLocalizedString("reset_password_check_email", comment: "")
            } else {
                switch response.errorCode() {
                case ErrorCode.emailNotExist.rawValue:
                    showAlert(title: NSLocalizedString("tip_name", comment: ""),
                              content: NSLocalizedString("email_not_exist", comment: ""),
                              controller: self)
                case ErrorCode.sendResetPasswordMail.rawValue:
                    showAlert(title: NSLocalizedString("tip_name", comment: ""),
                              content: NSLocalizedString("reset_password_failed", comment: ""),
                              controller: self)
                default:
                    break
                }
            }
        }
    }
}
