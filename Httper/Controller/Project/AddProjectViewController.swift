//
//  AddProjectViewController.swift
//  Httper
//
//  Created by Meng Li on 30/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit
import Eureka

class AddProjectViewController: UIViewController {
    
    private lazy var projectNameTextRow = TextRow() {
        $0.title = "Project Name"
        $0.placeholder = "Your project name"
    }
    
    private lazy var privilegePickerInputRow = PickerInputRow<String>(nil){
        $0.title = "Privilege"
        $0.options = ["Private"]
    }
    
    private lazy var introductionTextAreaRow = TextAreaRow("notes") {
        $0.placeholder = "Introduction"
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 200)
    }
    
    private lazy var section: Section = {
        let section = Section()
        section.append(projectNameTextRow)
        section.append(privilegePickerInputRow)
        section.append(introductionTextAreaRow)
        return section
    }()
    
    private lazy var formViewController: FormViewController = {
        let viewController = FormViewController()
        viewController.form.append(section)
        return viewController
    }()
    
    private let viewModel: AddProjectViewModel
    
    init(viewModel: AddProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(formViewController)
        view.addSubview(formViewController.view)
        formViewController.didMove(toParent: self)
    }

    // MARK: - Action
    /**
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
 */
}
