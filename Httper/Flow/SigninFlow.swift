//
//  SigninFlow.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxFlow

enum SigninStep: Step {
    case start
    case close
    case resetPassword
    case signup
}

class SigninFlow: Flow {
    
    var root: Presentable {
        navigationController
    }
    
    private lazy var navigationController: UINavigationController = {
        let controller = BaseNavigationController()
        controller.view.backgroundColor = .background
        return controller
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let signinStep = step as? SigninStep else {
            return .none
        }
        switch signinStep {
        case .start:
            return .none
        case .close:
            navigationController.dismiss(animated: true)
            return .none
        case .resetPassword:
            let resetPasswordViewController = ResetPasswordViewController(viewModel: .init())
            navigationController.pushViewController(resetPasswordViewController, animated: true)
            return .viewController(resetPasswordViewController)
        case .signup:
            let signupViewController = SignupViewController(viewModel: .init())
            navigationController.pushViewController(signupViewController, animated: true)
            return .viewController(signupViewController)
        }
    }
    
}