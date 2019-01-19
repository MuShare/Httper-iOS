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
    case project(Project)
    case request(Request)
    case add
}

class ProjectFlow: Flow {
    
    var root: Presentable {
        return projecstViewController
    }
    
    private lazy var projectsViewModel = ProjectsViewModel()
    private lazy var projecstViewController = ProjectsViewController(viewModel: projectsViewModel)

    private var navigationController: UINavigationController? {
        return projecstViewController.navigationController
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let projectStep = step as? ProjectStep else {
            return .none
        }
        switch projectStep {
        case .start:
            return .one(flowItem: NextFlowItem(nextPresentable: projecstViewController, nextStepper: projectsViewModel))
        case .project(let project):
            let projectViewModel = ProjectViewModel(project: project)
            let projectViewController = ProjectViewController(viewModel: projectViewModel)
            navigationController?.pushViewController(projectViewController, animated: true)
            return .one(flowItem: NextFlowItem(nextPresentable: projectViewController, nextStepper: projectViewModel))
        case .request(let request):
            let requestFlow = RequestFlow()
            Flows.whenReady(flow1: requestFlow) { root in
                self.navigationController?.pushViewController(root, animated: true)
            }
            return .one(flowItem: NextFlowItem(nextPresentable: requestFlow, nextStepper: OneStepper(withSingleStep: RequestStep.start(request))))
        case .add:
            let addProjectViewModel = AddProjectViewModel()
            let addProjectViewController = AddProjectViewController(viewModel: addProjectViewModel)
            navigationController?.pushViewController(addProjectViewController, animated: true)
            return .one(flowItem: NextFlowItem(nextPresentable: addProjectViewController, nextStepper: addProjectViewModel))
        }
    }
}
