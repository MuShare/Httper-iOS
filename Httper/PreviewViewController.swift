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
    
    var previewWebView: UIWebView!
    
    init?(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        previewWebView = {
            let view = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            return view
        }()
        
        //Set preview web view
        self.previewWebView.loadHTMLString(text, baseURL: nil)

        self.view.addSubview(previewWebView)

    }

}
