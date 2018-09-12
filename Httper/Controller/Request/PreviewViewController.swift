//
//  PreviewViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 09/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var text: String!
    var url: URL!
    
    var previewWebView: UIWebView!
    
    init?(text: String, url: URL) {
        self.text = text
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        previewWebView = {
            let view = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50))
            return view
        }()
        
        //Set preview web view
        self.previewWebView.loadHTMLString(text, baseURL: url)

        self.view.addSubview(previewWebView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: Style.preview.rawValue)
    }
    
}
