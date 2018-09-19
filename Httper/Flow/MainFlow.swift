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
    
    func navigate(to step: Step) -> NextFlowItems {
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
            return .multiple(flowItems: [
                NextFlowItem(nextPresentable: requestFlow, nextStepper: OneStepper(withSingleStep: RequestStep.start)),
                NextFlowItem(nextPresentable: projectFlow, nextStepper: OneStepper(withSingleStep: ProjectStep.start)),
                NextFlowItem(nextPresentable: settingsFlow, nextStepper: OneStepper(withSingleStep: SettingsStep.start))
            ])
        }
    }
    
}
