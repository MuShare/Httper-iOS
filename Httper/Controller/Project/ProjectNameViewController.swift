//
//  ProjectNameViewController.swift
//  Httper
//
//  Created by Meng Li on 17/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit

fileprivate struct Const {
    struct name {
        static let marginTop = 20
        static let height = 50
    }
}

class ProjectNameViewController: BaseViewController<ProjectNameViewModel> {

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "New Project Name", attributes: [.foregroundColor : UIColor.lightGray])
        textField.textColor = .white
        textField.textAlignment = .center
        textField.backgroundColor = .darkGray
        return textField
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        barButtonItem.rx.tap.bind { [unowned self] in
            self.viewModel.save()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
        navigationItem.rightBarButtonItem = saveBarButtonItem
        view.addSubview(nameTextField)
        createConstraints()
        
        nameTextField.becomeFirstResponder()
        
        viewModel.title ~> rx.title ~ disposeBag
        viewModel.isValidate ~> saveBarButtonItem.rx.isEnabled ~ disposeBag
        viewModel.name <~> nameTextField.rx.text ~ disposeBag
        
    }
    
    private func createConstraints() {
        
        nameTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeArea.top).offset(Const.name.marginTop)
            $0.height.equalTo(Const.name.height)
        }
        
    }
    
}
