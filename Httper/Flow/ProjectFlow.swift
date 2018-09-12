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
    
    private lazy var projecstViewController = R.storyboard.main.projectsViewController()!


    func navigate(to step: Step) -> NextFlowItems {
        guard let projectStep = step as? ProjectStep else {
            return .none
        }
        switch projectStep {
        case .start:
            let projectsViewModel = ProjectsViewModel()
            projecstViewController.viewModel = projectsViewModel
            return .one(flowItem: NextFlowItem(nextPresentable: projecstViewController, nextStepper: projectsViewModel))
        }
    }
}
