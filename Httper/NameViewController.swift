//
//  NameViewController.swift
//  Httper
//
//  Created by lidaye on 10/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyUserDefaults

class NameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!

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
        let params: Parameters = [
            "name": nameTextField.text!
        ]
        replaceBarButtonItemWithActivityIndicator(controller: self)
        Alamofire.request(createUrl("api/user/name"),
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                Defaults[.name] = self.nameTextField.text!
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                showAlert(title: NSLocalizedString("tip_name", comment: ""),
                          content: NSLocalizedString("token_error", comment: ""),
                          controller: self)
            }
        }
    }
    
}
