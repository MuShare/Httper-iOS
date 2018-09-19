//
//  ResponseHeaderViewController.swift
//  Httper
//
//  Created by lidaye on 13/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit

class ResponseHeaderViewController: UIViewController {

    var headerKey: String!
    var headerValue: String!
    
    @IBOutlet weak var headerKeyLabel: UILabel!
    @IBOutlet weak var headerValueTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerKeyLabel.text = headerKey
        headerValueTextView.text = headerValue
    }

}
