//
//  RequestFlow.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxFlow

enum RequestStep: Step {
    case start(Request?)
    case result(RequestData)
    case save(RequestData)
    case addProject
}

class RequestFlow: Flow {

    var root: Presentable {
        return requestViewController
    }
    
    private lazy var requestViewController = UIViewController()
    
    private var navigationController: UINavigationController? {
        return requestViewController.navigationController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let requestStep = step as? RequestStep else {
            return .none
        }
        switch requestStep {
        case .start(let request):
            let parametersViewModel = KeyValueViewModel()
            let parametersViewController = KeyValueViewController(viewModel: parametersViewModel)
            let headersViewModel = KeyValueViewModel()
            let headersViewController = KeyValueViewController(viewModel: headersViewModel)
            let bodyViewModel = BodyViewModel()
            let bodyViewController = BodyViewController(viewModel: bodyViewModel)

            let requestViewModel = RequestViewModel(request: request, headersViewModel: headersViewModel, parametersViewModel: parametersViewModel, bodyViewModel: bodyViewModel)
            let requestViewController = RequestViewController(viewModel: requestViewModel)
            requestViewController.contentViewControllers = [parametersViewController, headersViewController, bodyViewController]
            self.requestViewController = requestViewController
            
            return .multiple(flowContributors: [
                .viewController(requestViewController),
                .viewController(parametersViewController),
                .viewController(headersViewController),
                .viewController(bodyViewController),
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
            let saveToProjectViewModel = SaveToProjectViewModel()
            let saveToProjectViewController = SaveToProjectViewController(viewModel: saveToProjectViewModel)
            navigationController?.pushViewController(saveToProjectViewController, animated: true)
            return .viewController(saveToProjectViewController)
        case .addProject:
            let addProjectViewModel = AddProjectViewModel()
            let addProjectViewController = AddProjectViewController(viewModel: addProjectViewModel)
            navigationController?.pushViewController(addProjectViewController, animated: true)
            return .viewController(addProjectViewController)
        }
    }
    
    
}
