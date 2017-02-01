//
//  ProjectTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 30/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

class ProjectTableViewController: UITableViewController {

    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var privilegeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: - Action
    @IBAction func saveProject(_ sender: Any) {
        if projectNameTextField.text == "" {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("add_project_error", comment: ""),
                      controller: self)
            return
        }
        
    }
    
}
