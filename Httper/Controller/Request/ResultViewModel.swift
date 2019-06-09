//
//  ResultViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

class ResultViewModel: BaseViewModel {
    
    private let prettyViewModel: PrettyViewModel
    private let rawViewModel: RawViewModel
    private let previewViewModel: PreviewViewModel
    private let detailViewModel: DetailViewModel
    
    private let requestData: RequestData
    
    init(requestData: RequestData, prettyViewModel: PrettyViewModel, rawViewModel: RawViewModel, previewViewModel: PreviewViewModel, detailViewModel: DetailViewModel) {
        self.requestData = requestData
        self.prettyViewModel = prettyViewModel
        self.rawViewModel = rawViewModel
        self.previewViewModel = previewViewModel
        self.detailViewModel = detailViewModel
        
        super.init()
        
        loading.onNext(true)
        RequestManager.shared.send(requestData).subscribe(onNext: { [weak self] (response, data) in
            guard let `self` = self else {
                return
            }
            self.loading.onNext(false)
            guard let text = String(data: data, encoding: .utf8) else {
                self.alert.onNext(.tip("Nothing from this url."))
                return
            }
            self.prettyViewModel.set(text: text, headers: response.allHeaderFields)
            self.rawViewModel.set(text: text)
            self.previewViewModel.set(url: response.url, text: text)
            self.detailViewModel.response.onNext(response)
        }, onError: { [weak self] _ in
            self?.loading.onNext(false)
        }).disposed(by: disposeBag)
    }
    
    var title: Observable<String> {
        return Observable.just(requestData.url)
    }
    
}
