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
}

class SettingsFlow: Flow {
    
    var root: Presentable {
        return settingsTableViewController
    }
    
    private lazy var settingsTableViewController = R.storyboard.settings.settingsTableViewController()!
    
    func navigate(to step: Step) -> FlowContributors {
        guard let settingsStep = step as? SettingsStep else {
            return .none
        }
        switch settingsStep {
        case .start:
            let settingsViewModel = SettingsViewModel()
            settingsTableViewController.viewModel = settingsViewModel
            return .one(flowContributor: .viewController(settingsTableViewController, with: settingsViewModel))
        }
    }
    
}
