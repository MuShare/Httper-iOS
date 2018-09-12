//
//  ProjectNameViewController.swift
//  Httper
//
//  Created by Meng Li on 17/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit

class ProjectNameViewController: UIViewController {

    @IBOutlet weak var projectNameTextField: UITextField!
    
    var project: Project!
    let dao = DaoManager.shared
    let sync = SyncManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = project.pname
        projectNameTextField.becomeFirstResponder()
    }

    @IBAction func saveProjectName(_ sender: Any) {
        if projectNameTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.project_name_empty())

        }
        // Save project name to persistent store, and set project revision to 0.
        project.pname = projectNameTextField.text
        project.revision = 0
        dao.saveContext()
        sync.pushLocalProjects { (revision) in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}
