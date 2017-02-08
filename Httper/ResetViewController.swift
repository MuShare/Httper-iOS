//
//  ResetViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 08/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

class ResetViewController: EditingViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        self.shownHeight = submitButton.frame.maxY
        
        //Set background image
        let backgroundImageView: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            let ratio = view.frame.size.height / view.frame.size.width
            view.image = UIImage(named: ratio == 4 / 3 ? "register-bg-iPad.jpg" : "register-bg.jpg")
            return view
        }()
        self.view.insertSubview(backgroundImageView, at: 0)
    }

    // MARK: - Action
    @IBAction func back(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: Any) {
        
    }
}
