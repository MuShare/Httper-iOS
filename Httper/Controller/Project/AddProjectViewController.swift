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
        $0.title = "Project Name"
        $0.placeholder = "Your project name"
    }
    
    private lazy var privilegePickerInputRow = ActionSheetRow<String>() {
        $0.title = "Privilege"
        $0.selectorTitle = "Select Privilege"
        $0.options = ["Private"]
        $0.value = "Private"
    }.onPresent { from, to in
        to.popoverPresentationController?.permittedArrowDirections = .up
    }
    
    private lazy var introductionTextAreaRow = TextAreaRow("notes") {
        $0.placeholder = "Introduction"
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
        
        viewModel.title ~> rx.title ~ disposeBag
        viewModel.validate ~> saveBarButtonItem.rx.isEnabled ~ disposeBag
        viewModel.projectName <~> projectNameTextRow.rx.value ~ disposeBag
        viewModel.introduction <~> introductionTextAreaRow.rx.value ~ disposeBag
    }

}
