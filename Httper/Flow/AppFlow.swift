//
//  AppFlow.swift
//  Httper
//
//  Created by Meng Li on 2018/08/27.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxSwift
import RxFlow

enum AppStep: Step {
    case main
}

class AppFlow: Flow {
    
    var root: Presentable {
        return rootWindow
    }
    
    private let rootWindow: UIWindow
    
    private lazy var navigationController = HttperNavigationController()
    
    init(window: UIWindow) {
        rootWindow = window
        rootWindow.backgroundColor = .white
        rootWindow.rootViewController = navigationController
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let appStep = step as? AppStep else {
            return  .none
        }
        switch appStep {
        case .main:
            let mainFlow = MainFlow()
            Flows.whenReady(flow1: mainFlow) { [unowned self] mainViewController in
                self.navigationController.viewControllers = [mainViewController]
            }
            return .one(flowItem: NextFlowItem(nextPresentable: mainFlow, nextStepper: OneStepper(withSingleStep: MainStep.start)))
        }
    }
    
}
