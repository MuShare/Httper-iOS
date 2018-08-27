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
    
    private lazy var mainViewController = MainViewController()
    
    private var navigationController: UINavigationController? {
        return mainViewController.navigationController
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? MainStep else {
            return .none
        }
        switch step {
        case .start:
            return .none
        }
    }
    
}
