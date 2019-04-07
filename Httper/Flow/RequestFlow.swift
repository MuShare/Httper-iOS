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
    case result(RequestData)
    case save(RequestData)
    case saveIsCompleted
    case addProject(Step)
    case addProjectIsComplete
}

class RequestFlow: Flow {
    
    private let requestViewController: RequestViewController
    
    var root: Presentable {
        return requestViewController
    }

    private var navigationController: UINavigationController? {
        return requestViewController.navigationController
    }
    
    init(request: Request?) {
        let parametersViewModel = KeyValueViewModel()
        let parametersViewController = KeyValueViewController(viewModel: parametersViewModel)
        let headersViewModel = KeyValueViewModel()
        let headersViewController = KeyValueViewController(viewModel: headersViewModel)
        let bodyViewModel = BodyViewModel()
        let bodyViewController = BodyViewController(viewModel: bodyViewModel)
        
        let requestViewModel = RequestViewModel(request: request, headersViewModel: headersViewModel, parametersViewModel: parametersViewModel, bodyViewModel: bodyViewModel)
        
        requestViewController = RequestViewController(viewModel: requestViewModel)
        requestViewController.contentViewControllers = [parametersViewController, headersViewController, bodyViewController]
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let requestStep = step as? RequestStep else {
            return .none
        }
        switch requestStep {
        case .start:
//            guard let contentViewControllers = requestViewController.contentViewControllers as? [BaseViewController] else {
//                return .none
//            }
//            return .multiple(flowContributors:
//                [FlowContributor.viewController(requestViewController)] + contentViewControllers.map { FlowContributor.viewController($0) }
//            )
            return .multiple(flowContributors: [
                .viewController(requestViewController)
            ])

        case .result(let requestData):
            let prettyViewModel = PrettyViewModel()
            let prettyViewController = PrettyViewController(viewModel: prettyViewModel)
            let rawViewModel = RawViewModel()
            let rawViewController = RawViewController(viewModel: rawViewModel)
            let previewViewModel = PreviewViewModel()
            let previewViewController = PreviewViewController(viewModel: previewViewModel)
            let detailViewModel = DetailViewModel()
            let detailViewController = DetailViewController(viewModel: detailViewModel)
            
            let resultViewModel = ResultViewModel(requestData: requestData,
                                                  prettyViewModel: prettyViewModel,
                                                  rawViewModel: rawViewModel,
                                                  previewViewModel: previewViewModel,
                                                  detailViewModel: detailViewModel)
            let resultViewController = ResultViewController(viewModel: resultViewModel)
            resultViewController.contentViewControllers = [prettyViewController, rawViewController, previewViewController, detailViewController]
            navigationController?.pushViewController(resultViewController, animated: true)
            return .viewController(resultViewController)
        case .save(let requestData):
            let saveToProjectViewModel = SaveToProjectViewModel(requestData: requestData)
            let saveToProjectViewController = SaveToProjectViewController(viewModel: saveToProjectViewModel)
            navigationController?.pushViewController(saveToProjectViewController, animated: true)
            return .viewController(saveToProjectViewController)
        case .saveIsCompleted:
            guard navigationController?.topViewController is SaveToProjectViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        case .addProject(let step):
            let addProjectViewModel = AddProjectViewModel(endStep: step)
            let addProjectViewController = AddProjectViewController(viewModel: addProjectViewModel)
            navigationController?.pushViewController(addProjectViewController, animated: true)
            return .viewController(addProjectViewController)
        case .addProjectIsComplete:
            guard navigationController?.topViewController is AddProjectViewController else {
                return .none
            }
            navigationController?.popViewController(animated: true)
            return .none
        }
    }
    
    
}
