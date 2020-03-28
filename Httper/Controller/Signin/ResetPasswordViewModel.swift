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
        UserManager.shared.reset(email) { [weak self] success, tip in
            guard let `self` = self else {
                return
            }
            self.loading.onNext(false)
            
            if success {
                self.alert.onNextTip(R.string.localizable.reset_password_check_email()) {
                    self.steps.accept(SigninStep.resetPasswordIsComplete)
                }
            } else {
                self.alert.onNextTip(tip ?? R.string.localizable.common_error_unknown())
            }
        }
    }
    
}

extension ResetPasswordViewModel: KeyboardViewModel {
    var textFieldBottom: Observable<CGFloat> {
        return currentTextFieldFrameSubject.map {
            $0.origin.y + $0.height
        }
    }
}
