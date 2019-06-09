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
    case addProject(Step)
    case addProjectIsComplete
}

class MainFlow: Flow {
    
    var root: Presentable {
        return mainViewController
    }
    
    private let mainViewModel = MainViewModel()
    private lazy var mainViewController = MainViewController(viewModel: mainViewModel)
    
    private var requestViewController: RequestViewController?
    
    private var navigationController: UINavigationController? {
        return mainViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else {
            return .none
        }
        switch step {
        case .start:
            let requestFlow = RequestFlow(request: nil)
            let projectFlow = ProjectFlow()
            let settingsFlow = SettingsFlow()
            Flows.whenReady(flow1: requestFlow, flow2: projectFlow, flow3: settingsFlow) {
                self.mainViewController.viewControllers = [$0, $1, $2]
                self.requestViewController = $0 as? RequestViewController
            }
            return .multiple(flowContributors: [
                .contribute(withNextPresentable: mainViewController, withNextStepper: mainViewModel),
                .flow(requestFlow, with: RequestStep.start),
                .flow(projectFlow, with: ProjectStep.start),
                .flow(settingsFlow, with: SettingsStep.start)
            ])
        case .clearRequest:
            guard let requestViewController = requestViewController else {
                return .none
            }
            requestViewController.viewModel.clear()
            return .none
        case .addProject(let step):
            let addProjectViewModel = AddProjectViewModel(endStep: step)
            let addProjectViewController = AddProjectViewController(viewModel: addProjectViewModel)
            navigationController?.pushViewController(addProjectViewController, animated: true)
            return .viewController(addProjectViewController)
        case .addProjectIsComplete:
            guard navigationController?.topViewController is AddProjectViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        }
    }
    
}
