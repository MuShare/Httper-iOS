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
}

class RequestFlow: Flow {

    var root: Presentable {
        return requestViewController
    }
    
    private lazy var requestViewController = RequestViewController()
    
    private var navigationController: UINavigationController? {
        return requestViewController.navigationController
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let requestStep = step as? RequestStep else {
            return .none
        }
        switch requestStep {
        case .start:
            let parametersViewModel = KeyValueViewModel()
            let parametersViewController = KeyValueViewController(viewModel: parametersViewModel)
            let headersViewModel = KeyValueViewModel()
            let headersViewController = KeyValueViewController(viewModel: headersViewModel)
            let bodyViewModel = BodyViewModel()
            let bodyViewController = BodyViewController(viewModel: bodyViewModel)

            let requestViewModel = RequestViewModel(headersViewModel: headersViewModel, parametersViewModel: parametersViewModel, bodyViewModel: bodyViewModel)
            requestViewController.viewModel = requestViewModel
            requestViewController.contentViewControllers = [parametersViewController, headersViewController, bodyViewController]
            
            return .multiple(flowItems: [
                NextFlowItem(nextPresentable: requestViewController, nextStepper: requestViewModel),
                NextFlowItem(nextPresentable: parametersViewController, nextStepper: parametersViewModel),
                NextFlowItem(nextPresentable: headersViewController, nextStepper: headersViewModel),
                NextFlowItem(nextPresentable: bodyViewController, nextStepper: bodyViewModel)
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
            return .one(flowItem: NextFlowItem(nextPresentable: resultViewController, nextStepper: resultViewModel))
        }
    }
    
    
}
