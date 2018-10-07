//
//  ResetViewController.swift
//  Httper
//
//  Created by Meng Li on 08/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ResetViewController: EditingViewController, NVActivityIndicatorViewable {

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = R.image.loginBgJpg()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendEmailSuccessImageView: UIImageView!
    @IBOutlet weak var tipTextView: UITextView!
    
    var submit = false
    let user = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        view.insertSubview(backgroundImageView, at: 0)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        shownHeight = submitButton.frame.minY
    }

    // MARK: - Action
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        // If email is submitted before, back to sign in view
        if submit {
            navigationController?.popViewController(animated: true)
            return
        }
        if let email = emailTextField.text, !email.isEmailAddress {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.reset_password_not_validate())
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
                self.submitButton.setTitle(R.string.localizable.back_to_login(), for: .normal)
                self.titleLabel.text = R.string.localizable.reset_password_check_email()
            } else {
                self.showAlert(title: R.string.localizable.tip_name(), content: tip!)
            }
        }
    }
}
