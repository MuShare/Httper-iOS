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
    case projectIsComplete
    case request(Request)
    case name(Project)
    case nameIsComplete
    case introduction(Project)
    case introductionIsComplete
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
    
    func navigate(to step: Step) -> FlowContributors {
        guard let projectStep = step as? ProjectStep else {
            return .none
        }
        switch projectStep {
        case .start:
            return .viewController(projecstViewController)
        case .project(let project):
            let projectViewController = ProjectViewController(viewModel: .init(project: project))
            navigationController?.pushViewController(projectViewController, animated: true)
            return .viewController(projectViewController)
        case .projectIsComplete:
            guard navigationController?.topViewController is ProjectViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        case .request(let request):
            let requestFlow = RequestFlow(request: request)
            Flows.whenReady(flow1: requestFlow) { root in
                self.navigationController?.pushViewController(root, animated: true)
            }
            return .flow(requestFlow, with: RequestStep.start)
        case .name(let project):
            let projectNameViewController = ProjectNameViewController(viewModel: .init(project: project))
            navigationController?.pushViewController(projectNameViewController, animated: true)
            return .viewController(projectNameViewController)
        case .nameIsComplete:
            guard navigationController?.topViewController is ProjectNameViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        case .introduction(let project):
            let projectIntroductionViewController = ProjectIntroductionViewController(viewModel: .init(project: project))
            navigationController?.pushViewController(projectIntroductionViewController, animated: true)
            return .viewController(projectIntroductionViewController)
        case .introductionIsComplete:
            guard navigationController?.topViewController is ProjectIntroductionViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        }
    }
}
