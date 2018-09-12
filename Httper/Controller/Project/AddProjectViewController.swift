//
//  AddProjectViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 30/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

class AddProjectViewController: UIViewController {

    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var privilegeButton: UIButton!
    @IBOutlet weak var introudctionTextView: UITextView!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    let dao = DaoManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Action
    @IBAction func saveProject(_ sender: Any) {
        if projectNameTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.add_project_error())
            return
        }
        
        replaceBarButtonItemWithActivityIndicator()
        _ = dao.projectDao.save(pname: projectNameTextField.text!,
                                privilege: "private",
                                introduction: introudctionTextView.text!)
        SyncManager.shared.pushLocalProjects { (revision) in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
