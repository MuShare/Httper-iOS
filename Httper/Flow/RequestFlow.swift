//
//  RequestFlow.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxFlow

enum RequestStep: Step {
    case start
}

class RequestFlow: Flow {

    var root: Presentable {
        return requestViewController
    }
    
    private lazy var requestViewController = R.storyboard.main.requestViewController()!
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let requestStep = step as? RequestStep else {
            return .none
        }
        switch requestStep {
        case .start:
            let requestViewModel = RequestViewModel()
            requestViewController.viewModel = requestViewModel
            return .one(flowItem: NextFlowItem(nextPresentable: requestViewController, nextStepper: requestViewModel))
        }
    }
    
}
