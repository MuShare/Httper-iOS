//
//  PreviewViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var text: String!
    var url: URL!
    
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
        previewWebView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(topPadding)
            $0.bottom.equalToSuperview()
        }
        
//         previewWebView.loadHTMLString(text, baseURL: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: Style.preview.rawValue)
    }
    
}
