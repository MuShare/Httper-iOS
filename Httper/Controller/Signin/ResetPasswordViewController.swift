//
//  ResetPasswordViewController.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

private struct Const {
    
    struct close {
        static let size = 30
        static let margin = 20
    }
    
    struct logo {
        static let size = 100
        static let marginTop = 80
    }
    
    struct title {
        static let marginTop = 20
    }
    
    struct email {
        static let height = 50
        static let marginTop = 30
    }
    
    struct submit {
        static let height = 44
        static let margin = 20
    }
    
}

class ResetPasswordViewController: BaseViewController<ResetPasswordViewModel> {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = R.image.loginBgJpg()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.back(), for: .normal)
        button.rx.tap.bind { [unowned self] in
            self.viewModel.back()
            }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.logo()
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.reset_password_with_email()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = SigninTextField()
        textField.placeholder = "Email"
        textField.textColor = .white
        textField.backgroundColor = UIColor(hexa: 0xffffff44)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textAlignment = .center
        textField.keyboardType = .emailAddress
        textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [unowned self] in
            self.viewModel.openKeyboardForTextField(with: textField.frame)
        }).disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.reset_password_send_an_email(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = UIColor(hexa: 0xffffff44)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.rx.tap.bind { [unowned self] in
            self.viewModel.submit()
            }.disposed(by: disposeBag)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xf9f9f9)
        view.addSubview(backgroundImageView)
        view.addSubview(backButton)
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(submitButton)
        createConstraints()
        
        disposeBag ~ [
            viewModel.email <~> emailTextField.rx.text,
            viewModel.isSubmitEnabled ~> submitButton.rx.isEnabled,
            viewModel.viewOffset ~> rx.viewOffset
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
    }
    
    private func createConstraints() {
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(Const.close.size)
            $0.left.equalToSuperview().offset(Const.close.margin)
            $0.top.equalTo(view.safeArea.top).offset(Const.close.margin)
        }
        
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(Const.logo.size)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeArea.top).offset(Const.logo.marginTop)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImageView.snp.bottom).offset(Const.title.marginTop)
        }
        
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(Const.email.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(Const.email.marginTop)
        }
        
        submitButton.snp.makeConstraints {
            $0.height.equalTo(Const.submit.height)
            $0.left.equalToSuperview().offset(Const.submit.margin)
            $0.top.equalTo(emailTextField.snp.bottom).offset(Const.submit.margin)
            $0.right.equalToSuperview().offset(-Const.submit.margin)
        }
        
    }
    
}

extension ResetPasswordViewController: KeyboardViewController {}
