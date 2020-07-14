//
//  AddProjectViewController.swift
//  Httper
//
//  Created by Meng Li on 30/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit
import Eureka

class AddProjectViewController: BaseViewController<AddProjectViewModel> {
    
    private lazy var projectNameTextRow = TextRow() {
        $0.title = R.string.localizable.add_project_name_title()
        $0.placeholder = R.string.localizable.add_project_name_placeholder()
    }
    
    private lazy var privilegePickerInputRow = ActionSheetRow<String>() {
        $0.title = R.string.localizable.add_project_privilege_title()
        $0.selectorTitle = R.string.localizable.add_project_privilege_select()
        $0.options = ProjectPrivilege.allCases.map { $0.title }
        $0.value = ProjectPrivilege.private.title
    }.onPresent { from, to in
        to.popoverPresentationController?.permittedArrowDirections = .up
    }
    
    private lazy var introductionTextAreaRow = TextAreaRow("notes") {
        $0.placeholder = R.string.localizable.add_project_introduction_title()
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 200)
    }
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        barButtonItem.rx.tap.bind { [unowned self] in
            self.viewModel.saveProject()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        addChild(formViewController)
        view.addSubview(formViewController.view)
        formViewController.didMove(toParent: self)
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.validate ~> saveBarButtonItem.rx.isEnabled,
            viewModel.projectName <~> projectNameTextRow.rx.value,
            viewModel.introduction <~> introductionTextAreaRow.rx.value
        ]
    }

}
