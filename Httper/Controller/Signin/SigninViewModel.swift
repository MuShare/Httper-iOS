//
//  SigninViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

import FacebookLogin
import FBSDKLoginKit
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
        loading.onNext(true)
        UserManager.shared.loginWithEmail(email: email, password: password) { [weak self] success, tip in
            guard let `self` = self else {
                return
            }
            self.loading.onNext(false)
            if success {
                // Sync project and request entities from server
                SyncManager.shared.syncAll()
                // Close SigninViewController
                self.steps.accept(SigninStep.close)
            } else if !success, let tip = tip {
                self.alert.onNextTip(tip)
            }
        }
    }
    
    func signup() {
        steps.accept(SigninStep.signup)
    }
    
    func facebookSignin(viewController: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile], viewController: viewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                if DEBUG {
                    print("Facebook OAuth login error: \(error)");
                }
            case .cancelled:
                if DEBUG {
                    print("User cancelled login.");
                }
            case .success(_, _, let accessToken):
                self.loading.onNext(true)
                
                UserManager.shared.loginWithFacebook(accessToken.tokenString) { [weak self] (success, tip) in
                    guard let `self` = self else { return }
                    self.loading.onNext(false)
                    if success {
                        // Sync project and request entities from server
                        SyncManager.shared.syncAll()
                        
                        self.steps.accept(SigninStep.close)
                    } else {
                        self.alert.onNextTip(tip ?? R.string.localizable.common_error_unknown())
                    }
                }
            }
        }
    }
    
}

extension SigninViewModel: KeyboardViewModel {
    var textFieldBottom: Observable<CGFloat> {
        currentTextFieldFrameSubject.map {
            $0.origin.y + $0.height
        }
    }
}
