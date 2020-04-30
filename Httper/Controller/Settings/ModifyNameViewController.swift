//
//  ModifyNameViewController.swift
//  Httper
//
//  Created by Meng Li on 2020/2/10.
//  Copyright © 2020 MuShare. All rights reserved.
//

private struct Const {
    struct name {
        static let marginTop = 20
        static let height = 50
    }
}

class ModifyNameViewController: BaseViewController<ModifyNameViewModel> {

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        barButtonItem.rx.tap.bind { [unowned self] in
            self.viewModel.save()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .navigation
        textField.textColor = .white
        textField.textAlignment = .center
        textField.becomeFirstResponder()
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = saveBarButtonItem
        view.backgroundColor = .background
        view.addSubview(nameTextField)
        createConstraints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.name <~> nameTextField.rx.value,
            viewModel.isSaveEnabled ~> saveBarButtonItem.rx.isEnabled
        ]
    }
    
    override func createConstraints() {
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(Const.name.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeArea.top).offset(Const.name.marginTop)
        }
    }
    
}
