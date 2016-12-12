//
//  RequestBodyViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 12/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class RequestBodyViewController: UIViewController {

    var body: String!
    
    @IBOutlet weak var rawBodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rawBodyTextView.text = body
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        rawBodyTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bodyChanged"), object: rawBodyTextView.text)
    }

    //MARK: - Action
    @IBAction func cleatRequestBody(_ sender: Any) {
        rawBodyTextView.text = ""
    }
}
