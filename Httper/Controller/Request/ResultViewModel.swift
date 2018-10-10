//
//  ResultViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

class ResultViewModel {
    
    private let prettyViewModel: PrettyViewModel
    private let rawViewModel: RawViewModel
    private let previewViewModel: PreviewViewModel
    private let detailViewModel: DetailViewModel
    
    private let requestData: RequestData
    private let disposeBag = DisposeBag()
    
    init(requestData: RequestData, prettyViewModel: PrettyViewModel, rawViewModel: RawViewModel, previewViewModel: PreviewViewModel, detailViewModel: DetailViewModel) {
        self.requestData = requestData
        self.prettyViewModel = prettyViewModel
        self.rawViewModel = rawViewModel
        self.previewViewModel = previewViewModel
        self.detailViewModel = detailViewModel
        
        RequestManager.shared.send(requestData).subscribe(onNext: { [weak self] (response, data) in
            guard
                response.statusCode == 200,
                let `self` = self,
                let text = String(data: data, encoding: .utf8)
            else {
                return
            }
            self.prettyViewModel.set(text: text, headers: response.allHeaderFields)
            self.rawViewModel.set(text: text)
            self.previewViewModel.set(url: response.url, text: text)
        }, onError: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
}

extension ResultViewModel: Stepper {
    
}
