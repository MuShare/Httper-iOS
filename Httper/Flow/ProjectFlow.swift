//
//  ProjectFlow.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxFlow

enum ProjectStep: Step {
    case start
}

class ProjectFlow: Flow {
    
    var root: Presentable {
        return projecstViewController
    }
    
    private lazy var projectsViewModel = ProjectsViewModel()
    private lazy var projecstViewController = ProjectsViewController(viewModel: projectsViewModel)

    func navigate(to step: Step) -> NextFlowItems {
        guard let projectStep = step as? ProjectStep else {
            return .none
        }
        switch projectStep {
        case .start:
            return .one(flowItem: NextFlowItem(nextPresentable: projecstViewController, nextStepper: projectsViewModel))
        }
    }
}
