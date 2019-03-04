//
//  MainFlow.swift
//  Httper
//
//  Created by Meng Li on 2018/08/27.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxFlow

enum MainStep: Step {
    case start
    case clearRequest
    case addRequest
}

class MainFlow: Flow {
    
    var root: Presentable {
        return mainViewController
    }
    
    private let mainViewModel = MainViewModel()
    private lazy var mainViewController = MainViewController(viewModel: mainViewModel)
    
    private var navigationController: UINavigationController? {
        return mainViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else {
            return .none
        }
        switch step {
        case .start:
            let requestFlow = RequestFlow()
            let projectFlow = ProjectFlow()
            let settingsFlow = SettingsFlow()
            Flows.whenReady(flow1: requestFlow, flow2: projectFlow, flow3: settingsFlow) { requestRoot, projectRoot, settingsRoot in
                self.mainViewController.viewControllers = [requestRoot, projectRoot, settingsRoot]
            }
            return .multiple(flowContributors: [
                .contribute(withNextPresentable: mainViewController, withNextStepper: mainViewModel),
                .flow(requestFlow, with: RequestStep.start(nil)),
                .flow( projectFlow, with: ProjectStep.start),
                .flow( settingsFlow, with: SettingsStep.start)
            ])
        case .clearRequest:
            
            return .none
        case .addRequest:
            let addProjectViewModel = AddProjectViewModel()
            let addProjectViewController = AddProjectViewController(viewModel: addProjectViewModel)
            navigationController?.pushViewController(addProjectViewController, animated: true)
            return .viewController(addProjectViewController)
        }
    }
    
}
