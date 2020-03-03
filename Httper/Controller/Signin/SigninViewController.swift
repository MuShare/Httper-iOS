//
//  SigninViewController.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

private enum Const {
    
    struct back {
        static let size = 30
        static let margin = 20
    }
    
    struct logo {
        static let size = 100
        static let marginTop = 50
    }
    
    struct title {
        static let marginTop = 20
    }
    
    struct email {
        static let height = 50
        static let marginTop = 30
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
    
    struct forgot {
        static let marginTop = 20
    }
    
    struct signup {
        static let height = 44
        static let margin = 20
    }
    
}

class SigninWithEmailViewController: BaseViewController<SigninViewModel> {
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.back(), for: .normal)
        button.rx.tap.bind { [unowned self] in
            self.viewModel.close()
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
        label.text = R.string.localizable.signin_title()
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = SigninTextField()
        textField.placeholder = "Email"
        textField.textAlignment = .center
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.addTarget(passwordTextField, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { [unowned self] in
            self.viewModel.openKeyboardForTextField(with: textField.frame)
        }).disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = SigninTextField()
        textField.placeholder = "Password"
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
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
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.rx.tap.bind { [unowned self] in
            self.viewModel.submit()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var forgotButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forget Password", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.rx.tap.bind { [unowned self] in
            self.viewModel.forgotPassword()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign up now!", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.rx.tap.bind { [unowned self] in
            self.viewModel.signup()
        }.disposed(by: disposeBag)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: 0xf9f9f9)
        view.addSubview(closeButton)
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(showPasswordButton)
        view.addSubview(submitButton)
        view.addSubview(forgotButton)
        view.addSubview(signupButton)
        createConstraints()
        
        disposeBag ~ [
            viewModel.emailRelay <~> emailTextField.rx.text,
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
        
        closeButton.snp.makeConstraints {
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
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(Const.password.height)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(emailTextField.snp.bottom).offset(Const.password.marginTop)
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
        
        forgotButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(submitButton.snp.bottom).offset(Const.forgot.marginTop)
        }

        signupButton.snp.makeConstraints {
            $0.height.equalTo(Const.signup.height)
            $0.left.equalToSuperview().offset(Const.signup.margin)
            $0.right.equalToSuperview().offset(-Const.signup.margin)
            $0.bottom.equalTo(view.safeArea.bottom).offset(-Const.signup.margin)
        }
        
    }
    
}

extension SigninWithEmailViewController: KeyboardViewController {}