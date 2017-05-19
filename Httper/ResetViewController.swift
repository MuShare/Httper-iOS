//
//  ResetViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 08/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ResetViewController: EditingViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendEmailSuccessImageView: UIImageView!
    @IBOutlet weak var tipTextView: UITextView!
    
    var submit = false
    let user = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //Set background image
        let backgroundImageView: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            let ratio = view.frame.size.height / view.frame.size.width
            view.image = UIImage(named: ratio == 4 / 3 ? "register-bg-iPad.jpg" : "register-bg.jpg")
            return view
        }()
        self.view.insertSubview(backgroundImageView, at: 0)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        self.shownHeight = submitButton.frame.minY
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
        
        finishEdit()
        startAnimating()
        user.reset(emailTextField.text!) { (success, tip) in
            self.stopAnimating()
            
            if success {
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
                showAlert(title: NSLocalizedString("tip_name", comment: ""),
                          content: tip!,
                          controller: self)
            }
        }
    }
}
