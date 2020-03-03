//
//  SigninViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift

class SigninViewModel: BaseViewModel {
    
    private var currentTextFieldFrameSubject = PublishSubject<CGRect>()
    private let isSecureTextEntryRelay = BehaviorRelay<Bool>(value: true)
    
    let emailRelay = BehaviorRelay<String?>(value: nil)
    let passwordRelay = BehaviorRelay<String?>(value: nil)
    
    var isSubmitEnabled: Observable<Bool> {
        return Observable.combineLatest(emailRelay, passwordRelay) { email, password in
            guard let email = email, let password = password else {
                return false
            }
            return !email.isEmpty && email.isEmailAddress && !password.isEmpty
        }
    }

    var isSecureTextEntry: Observable<Bool> {
        isSecureTextEntryRelay.asObservable()
    }
    
    var showPasswordImage: Observable<UIImage?> {
        isSecureTextEntry.map {
            $0 ? R.image.password_hidden() : R.image.password_shown()
        }
    }
    
    func switchSecureTextEntry() {
        isSecureTextEntryRelay.accept(!isSecureTextEntryRelay.value)
    }
    
    func openKeyboardForTextField(with frame: CGRect) {
        currentTextFieldFrameSubject.onNext(frame)
    }
    
    func close() {
        steps.accept(SigninStep.close)
    }
    
    func set(email: String, password: String) {
        emailRelay.accept(email)
        passwordRelay.accept(password)
    }
    
    func forgotPassword() {
        steps.accept(SigninStep.resetPassword)
    }

    func submit() {
        guard
            let email = emailRelay.value, !email.isEmpty, email.isEmailAddress,
            let password = passwordRelay.value, !password.isEmpty
        else {
            return
        }
        
//        UserManager.shared.signinWithEmail(email: email, password: password, prepare: { [weak self] in
//            self?.loading.onNext(true)
//        }, success: { [weak self] in
//            self?.loading.onNext(false)
//            self?.steps.accept(SigninStep.complete)
//        }, resendEmail: { [weak self] in
//            self?.alert.onNextTip(R.string.localizable.signup_error_mail_is_not_verified())
//        }, error: { [weak self] in
//            self?.loading.onNext(false)
//            switch $0 {
//            case .invalidPassword:
//                self?.alert.onNextError(R.string.localizable.signup_error_invalid_password())
//            case .mailIsNotExsit:
//                self?.alert.onNextError(R.string.localizable.signup_error_mail_is_not_exists())
//            default:
//                self?.alert.onNextError(R.string.localizable.signup_error_unknown())
//            }
//        })
    }
    
    func signup() {
        steps.accept(SigninStep.signup)
    }
    
    func facebookSignin() {
        
    }
    
}

extension SigninViewModel: KeyboardViewModel {
    var textFieldBottom: Observable<CGFloat> {
        currentTextFieldFrameSubject.map {
            $0.origin.y + $0.height
        }
    }
}
