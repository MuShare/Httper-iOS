//
//  SettingsFlow.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxFlow

enum SettingsStep: Step {
    case start
    case signin
    case profile
    case profileIsComplete
    case modifyNameIsComplete
    case modifyName
    case keyboard
    case ping
    case whois
    case ip
}

class SettingsFlow: Flow {
    
    var root: Presentable {
        return settingsViewController
    }
    
    private lazy var settingsViewController = SettingsViewController(viewModel: .init())
    
    private var navigationController: UINavigationController? {
        return settingsViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let settingsStep = step as? SettingsStep else {
            return .none
        }
        switch settingsStep {
        case .start:
            return .viewController(settingsViewController)
        case .signin:
            let signinFlow = SigninFlow()
            Flows.use(signinFlow, when: .ready) {
                self.settingsViewController.present($0, animated: true)
            }
            return .flow(signinFlow, with: SigninStep.start)
        case .profile:
            let profileViewController = ProfileViewController(viewModel: .init())
            navigationController?.pushViewController(profileViewController, animated: true)
            return .viewController(profileViewController)
        case .profileIsComplete:
            guard navigationController?.topViewController is ProfileViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        case .modifyName:
            let modifyNameViewController = ModifyNameViewController(viewModel: .init())
            navigationController?.pushViewController(modifyNameViewController, animated: true)
            return .viewController(modifyNameViewController)
        case .modifyNameIsComplete:
            guard navigationController?.topViewController is ModifyNameViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        case .keyboard:
            let keyboardAccessoruViewController = KeyboardAccessoryViewController(viewModel: .init())
            navigationController?.pushViewController(keyboardAccessoruViewController, animated: true)
            return .viewController(keyboardAccessoruViewController)
        case .ping:
            let pingViewController = PingViewController(viewModel: .init())
            navigationController?.pushViewController(pingViewController, animated: true)
            return .viewController(pingViewController)
        case .whois:
            let whoisViewController = WhoisViewController(viewModel: .init())
            navigationController?.pushViewController(whoisViewController, animated: true)
            return .viewController(whoisViewController)
        case .ip:
            let ipAddressViewController = IPAddressViewController(viewModel: .init())
            navigationController?.pushViewController(ipAddressViewController, animated: true)
            return .viewController(ipAddressViewController)
        }
    }
    
}
