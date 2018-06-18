//
//  PrettyViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 09/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import M80AttributedLabel
import Alamofire
import MGFormatter

class PrettyViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private lazy var formatterView = FormatterView()
    
    var text: String!
    var headers: [AnyHashable : Any]!
    
    init?(text: String, headers: [AnyHashable : Any]) {
        self.text = text
        self.headers = headers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(formatterView)
        formatterView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        let contentType = headers["Content-Type"] as? String
        if contentType == nil {
            formatterView.format(string: text, style: .dark)
        } else if contentType!.contains("text/html") {
            formatterView.format(string: text, style: .dark)
        } else if contentType!.contains("application/json") {
            formatterView.format(string: text, style: .dark)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentPageChanged"), object: Style.pretty.rawValue)
    }
    
}
