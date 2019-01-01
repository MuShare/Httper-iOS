//
//  EditingViewController.swift
//  Httper
//
//  Created by Meng Li on 16/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit

let keyboardHeight: CGFloat = 340.0

class EditingViewController: UIViewController, UITextFieldDelegate {

    var editingTextField: UITextField!
    var shownHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITextViewDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
        let offset = keyboardHeight - (self.view.frame.size.height - shownHeight)
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
    
    // MARK: - Service
    func finishEdit() {
        if editingTextField.isFirstResponder {
            editingTextField.resignFirstResponder()
        }
    }
    
}
