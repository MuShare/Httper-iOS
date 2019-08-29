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
