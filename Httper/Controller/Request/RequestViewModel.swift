//
//  RequestViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
import RxKeyboard
import MGSelector
import Alamofire

struct RequestConst {
    static let protocols = ["http", "https"]
    static let methods = ["GET", "POST", "HEAD", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
}

struct DetailOption {
    var key: String
}

extension DetailOption: MGSelectorOption {
    
    var title: String {
        return key
    }
    
    var detail: String? {
        switch key {
        case "GET": return R.string.parameters.get()
        case "POST": return R.string.parameters.post()
        case "HEAD": return R.string.parameters.head()
        case "PUT": return R.string.parameters.put()
        case "DELETE": return R.string.parameters.delete()
        case "CONNECT": return R.string.parameters.connect()
        case "OPTIONS": return R.string.parameters.options()
        case "TRACE": return R.string.parameters.trace()
        case "PATCH": return R.string.parameters.patch()
        default: return nil
        }
    }
    
}

class RequestViewModel: BaseViewModel {
    
    private let request: Request?
    private let headersViewModel: KeyValueViewModel
    private let parametersViewModel: KeyValueViewModel
    private let bodyViewModel: BodyViewModel
    
    init(request: Request?, headersViewModel: KeyValueViewModel, parametersViewModel: KeyValueViewModel, bodyViewModel: BodyViewModel) {
        self.request = request
        self.headersViewModel = headersViewModel
        self.parametersViewModel = parametersViewModel
        self.bodyViewModel = bodyViewModel
        super.init()
        
        if let method = request?.method {
            requestMethod.accept(method)
        }
        if let urlString = request?.url {
            let splits = urlString.components(separatedBy: "://")
            if splits.count == 2 {
                requestProtocol.accept(RequestConst.protocols.firstIndex(of: splits[0]) ?? 0)
                url.accept(splits[1])
            }
        }
        if let requestData = request?.parameters as Data?,
           let parameters =  NSKeyedUnarchiver.unarchiveObject(with: requestData) as? Parameters,
           !parameters.isEmpty {
            parametersViewModel.keyValuesRelay.accept(parameters.map {
                KeyValue(key: $0.key, value: $0.value as? String ?? "")
            })
        }
        if let headerData = request?.headers as Data?,
           let headers = NSKeyedUnarchiver.unarchiveObject(with: headerData) as? StorageHttpHeaders,
           !headers.isEmpty {
            headersViewModel.keyValuesRelay.accept(headers.map {
                KeyValue(key: $0.key, value: $0.value)
            })
        }
        if let bodyData = request?.body as Data?, let body = String(data: bodyData, encoding: .utf8) {
            bodyViewModel.body.accept(body)
        }
    }
    
    let requestMethod = BehaviorRelay<String>(value: RequestConst.methods[0])
    let url = BehaviorRelay<String?>(value: nil)
    let requestProtocol = BehaviorRelay<Int>(value: 0)
    
    var valueOriginY: CGFloat = 0
    
    private var editingState: Observable<KeyValueEditingState> {
        Observable
            .merge(parametersViewModel.editingStateSubject, headersViewModel.editingStateSubject)
            .distinctUntilChanged {
                switch ($0, $1) {
                case (.begin(let height1), .begin(let height2)):
                    return height1 == height2
                case (.end, .end):
                    return true
                default:
                    return false
                }
            }
    }

    var moveupHeight: Observable<CGFloat> {
        Observable
            .combineLatest(
                editingState,
                RxKeyboard.instance.visibleHeight.skip(1).asObservable()
            )
            .map { [unowned self] in
                let (state, keyboardHeight) = $0
                switch state {
                case .begin(let height):
                    return max(keyboardHeight + valueOriginY + height - UIScreen.main.bounds.height, 0)
                case .end:
                    return 0
                }
            }
            .debug()
    }
    
    var requestData: RequestData {
        RequestData(
            method: requestMethod.value,
            url: RequestConst.protocols[requestProtocol.value] + "://" + (url.value ?? ""),
            headers: headersViewModel.keyValues,
            parameters: parametersViewModel.keyValues,
            body: bodyViewModel.body.value ?? ""
        )
    }
    
    var title: Observable<String> {
        Observable.just(request)
            .unwrap()
            .map { _ in R.string.localizable.request_title() }
    }

    var characters: Observable<[String]> {
        UserManager.shared.charactersRelay.asObservable()
    }
    
    func sendRequest() {
        guard let url = url.value, !url.isEmpty else {
            alert.onNext(.warning(R.string.localizable.request_url_empty()))
            return
        }
        steps.accept(RequestStep.result(requestData))
    }
    
    func saveToProject() {
        guard let url = url.value, !url.isEmpty else {
            alert.onNext(.warning(R.string.localizable.request_url_empty()))
            return
        }
        steps.accept(RequestStep.save(requestData))
    }
    
    func clear() {
        alert.onNextCustomConfirm(
            title: R.string.localizable.request_clear_title(),
            message: R.string.localizable.request_clear_title(),
            onConfirm: { [unowned self] in
                self.requestMethod.accept(RequestConst.methods[0])
                self.url.accept(nil)
                self.requestProtocol.accept(0)
                self.parametersViewModel.clear()
                self.headersViewModel.clear()
                self.bodyViewModel.clear()
            }
        )
    }
    
}
