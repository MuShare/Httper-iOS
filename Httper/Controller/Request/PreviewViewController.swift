//
//  PreviewViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import RxSwift

class PreviewViewController: UIViewController {

    private lazy var previewWebView = UIWebView()
    
    private let viewModel: PreviewViewModel

    init(viewModel: PreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(previewWebView)
        createConstraints()
        
        Observable.combineLatest(viewModel.text, viewModel.url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (text, url) in
                self?.previewWebView.loadHTMLString(text, baseURL: url)
            }).disposed(by: disposeBag)
    }
    
    private func createConstraints() {
        previewWebView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
}
