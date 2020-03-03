//
//  SignupViewController.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift

private struct Const {
    
    struct back {
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
    
    struct username {
        static let height = 50
        static let marginTop = 2
    }
    
    struct password {
        static let height = 50
        static let marginTop = 2
    }
    
    struct showPassword {
        static let size = 20
        static let marginRight = 20
    }
    
    struct submit {
        static let height = 44
        static let margin = 20
    }

}

class SignupViewController: BaseViewController<SignupViewModel> {
    
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
        label.text = R.string.localizable.signup_title()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = SigninTextField()
        textField.placeholder = R.string.localizable.signup_email()
        textField.backgroundColor = UIColor(hexa: 0xffffff44)
        textField.keyboardType = .emailAddress
        textField.textAlignment = .center
        textField.returnKeyType = .next
        textField.addTarget(usernameTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [unowned self] in
            self.viewModel.openKeyboardForTextField(with: textField.frame)
        }).disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = SigninTextField()
        textField.placeholder = R.string.localizable.signup_username()
        textField.backgroundColor = UIColor(hexa: 0xffffff44)
        textField.textAlignment = .center
        textField.returnKeyType = .next
        textField.addTarget(passwordTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [unowned self] in
            self.viewModel.openKeyboardForTextField(with: textField.frame)
        }).disposed(by: disposeBag)
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = SigninTextField()
        textField.placeholder = R.string.localizable.signup_password()
        textField.backgroundColor = UIColor(hexa: 0xffffff44)
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [unowned self] in
            self.viewModel.openKeyboardForTextField(with: textField.frame)
        }).disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var showPasswordButton: UIButton = {
        let button = UIButton()
        button.rx.tap.bind { [unowned self] in
            self.viewModel.switchSecureTextEntry()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.signup_submit(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.setTitleColor(.lightGray, for: .disabled)
        button.backgroundColor = UIColor(hexa: 0xffffff44)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.rx.tap.bind {[unowned self] in
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
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(showPasswordButton)
        view.addSubview(submitButton)
        createConstraints()
        
        disposeBag ~ [
            viewModel.emailRelay <~> emailTextField.rx.text,
            viewModel.usernameRelay <~> usernameTextField.rx.text,
            viewModel.passwordRelay <~> passwordTextField.rx.text,
            viewModel.isSecureTextEntry ~> passwordTextField.rx.isSecureTextEntry,
            viewModel.showPasswordImage ~> showPasswordButton.rx.image(),
            viewModel.isSubmitEnabled ~> submitButton.rx.isEnabled,
            viewModel.viewOffset ~> rx.viewOffset
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func createConstraints() {
        
        backButton.snp.makeConstraints {
            $0.size.equalTo(Const.back.size)
            $0.left.equalToSuperview().offset(Const.back.margin)
            $0.top.equalTo(view.safeArea.top).offset(Const.back.margin)
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
        
        usernameTextField.snp.makeConstraints {
            $0.height.equalTo(Const.username.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(emailTextField.snp.bottom).offset(Const.username.marginTop)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(Const.password.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(usernameTextField.snp.bottom).offset(Const.password.marginTop)
        }
        
        showPasswordButton.snp.makeConstraints {
            $0.size.equalTo(Const.showPassword.size)
            $0.centerY.equalTo(passwordTextField)
            $0.right.equalTo(passwordTextField).offset(-Const.showPassword.marginRight)
        }
        
        submitButton.snp.makeConstraints {
            $0.height.equalTo(Const.submit.height)
            $0.left.equalToSuperview().offset(Const.submit.margin)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Const.submit.margin)
            $0.right.equalToSuperview().offset(-Const.submit.margin)
        }
        
    }
    
}

extension SignupViewController: KeyboardViewController {}
