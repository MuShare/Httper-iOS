//
//  RxFlow+Extension.swift
//  Rinrin
//
//  Created by Meng Li on 2019/01/30.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxFlow

extension FlowContributors {
    
    static func viewController<ViewModel: BaseViewModel>(_ viewController: BaseViewController<ViewModel>) -> FlowContributors {
        return .one(flowContributor: .viewController(viewController))
    }
    
    static func flow(_ flow: Flow, with step: Step) -> FlowContributors {
        return .one(flowContributor: .flow(flow, with: step))
    }
    
}

extension FlowContributor {
    
    static func viewController<ViewModel: BaseViewModel>(_ viewController: BaseViewController<ViewModel>) -> FlowContributor {
        return .contribute(withNextPresentable: viewController, withNextStepper: viewController.viewModel)
    }
    
    static func viewController(_ viewController: UIViewController, with viewModel: Stepper) -> FlowContributor {
        return .contribute(withNextPresentable: viewController, withNextStepper: viewModel)
    }
    
    static func flow(_ flow: Flow, with step: Step) -> FlowContributor {
        return .contribute(withNextPresentable: flow, withNextStepper: OneStepper(withSingleStep: step))
    }
    
}
