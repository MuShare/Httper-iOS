//
//  PreviewViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import RxSwift

class PreviewViewController: BaseViewController<PreviewViewModel> {

    private lazy var previewWebView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(previewWebView)
        createConstraints()
        
        viewModel.content.subscribe(onNext: { [unowned self] (text, url) in
            self.previewWebView.loadHTMLString(text, baseURL: url)
        }).disposed(by: disposeBag)

    }
    
    override func createConstraints() {
        previewWebView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
}
