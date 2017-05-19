//
//  NameViewController.swift
//  Httper
//
//  Created by lidaye on 10/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NameViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!

    let user = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Show keyboard.
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save(saveBarButtonItem)
        return true
    }
    
    // MARK: - Action
    @IBAction func save(_ sender: Any) {
        if nameTextField.text == "" {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("name_not_empty", comment: ""),
                      controller: self)
            return
        }
        
        startAnimating()
        user.modifyName(nameTextField.text!) { (success, tip) in
            self.stopAnimating()
            if success {
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                showAlert(title: NSLocalizedString("tip_name", comment: ""),
                          content: tip!,
                          controller: self)
            }
        }

    }
    
}
