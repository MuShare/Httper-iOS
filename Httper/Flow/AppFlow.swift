//
//  AppFlow.swift
//  Httper
//
//  Created by mon.ri on 2018/08/27.
//  Copyright © 2018 limeng. All rights reserved.
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
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: MainViewController())
        navigationController.navigationBar.tintColor = UIColor(hex: 0xffffff)
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor(hex: 0xffffff)
        ]
        navigationController.navigationBar.barTintColor = UIColor(hex: 0x4e5255)
        return navigationController
    }()
    
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
