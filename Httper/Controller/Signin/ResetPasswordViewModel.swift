//
//  ResetPasswordViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//


import RxCocoa
import RxSwift

class ResetPasswordViewModel: BaseViewModel {
    
    private var currentTextFieldFrameSubject = PublishSubject<CGRect>()
    
    let email = BehaviorRelay<String?>(value: nil)
    
    var isSubmitEnabled: Observable<Bool> {
        return email.map {
            guard let email = $0 else {
                return false
            }
            return !email.isEmpty && email.isEmailAddress
        }
    }
    
    func openKeyboardForTextField(with frame: CGRect) {
        currentTextFieldFrameSubject.onNext(frame)
    }
    
    func back() {
        steps.accept(SigninStep.resetPasswordIsComplete)
    }
    
    func submit() {
        guard let email = email.value, !email.isEmpty, email.isEmailAddress else {
            return
        }
        loading.onNext(true)
//        Pluto.shared.resetPassword(address: email, success: { [weak self] in
//            self?.loading.onNext(false)
//            self?.alert.onNextTip(R.string.localizable.signup_send_mail_to_reset_password()) {
//                self?.steps.accept(SigninStep.forgotIsComplete)
//            }
//        }, error: { [weak self] in
//            self?.loading.onNext(false)
//            self?.loading.onNext(false)
//            switch $0 {
//            case .mailIsAlreadyRegister:
//                self?.alert.onNextError(R.string.localizable.signup_error_mail_already_registered())
//            default:
//                self?.alert.onNextError(R.string.localizable.signup_error_unknown())
//            }
//        })
    }
    
}

extension ResetPasswordViewModel: KeyboardViewModel {
    var textFieldBottom: Observable<CGFloat> {
        return currentTextFieldFrameSubject.map {
            $0.origin.y + $0.height
        }
    }
}
