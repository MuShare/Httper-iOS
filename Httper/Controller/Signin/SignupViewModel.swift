//
//  SignupViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxCocoa
import RxKeyboard
import RxSwift

class SignupViewModel: BaseViewModel {
    
    private let currentTextFieldFrameSubject = PublishSubject<CGRect>()
    private let isSecureTextEntryRelay = BehaviorRelay<Bool>(value: true)
    
    let emailRelay = BehaviorRelay<String?>(value: nil)
    let usernameRelay = BehaviorRelay<String?>(value: nil)
    let passwordRelay = BehaviorRelay<String?>(value: nil)
    
    var isSubmitEnabled: Observable<Bool> {
        return Observable.combineLatest(emailRelay, usernameRelay, passwordRelay) { email, username, password in
            guard let email = email, let username = username, let password = password else {
                return false
            }
            return !email.isEmpty && email.isEmailAddress && !username.isEmpty && !password.isEmpty
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
    
    func openKeyboardForTextField(with frame: CGRect) {
        currentTextFieldFrameSubject.onNext(frame)
    }
    
    func back() {
        steps.accept(SigninStep.signupIsComplete(email: nil, password: nil))
    }
    
    func submit() {
        guard
            let email = emailRelay.value, !email.isEmpty, email.isEmailAddress,
            let username = usernameRelay.value, !username.isEmpty,
            let password = passwordRelay.value, !password.isEmpty
        else {
            return
        }
        loading.onNext(true)
        UserManager.shared.register(email: email, name: username, password: password) { [weak self] success, tip in
            guard let `self` = self else {
                return
            }
            self.loading.onNext(false)
            if success {
                self.steps.accept(SigninStep.signupIsComplete(email: email, password: password))
            } else {
                self.alert.onNextTip(tip ?? R.string.localizable.error_unknown())
            }
        }
    }
    
    func switchSecureTextEntry() {
        isSecureTextEntryRelay.accept(!isSecureTextEntryRelay.value)
    }
    
}

extension SignupViewModel: KeyboardViewModel {
    var textFieldBottom: Observable<CGFloat> {
        currentTextFieldFrameSubject.map {
            $0.origin.y + $0.height
        }
    }
}
