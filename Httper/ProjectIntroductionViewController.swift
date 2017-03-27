//
//  ProjectIntroductionViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 17/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

class ProjectIntroductionViewController: UIViewController {

    @IBOutlet weak var introductionTextView: UITextView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = project.pname
        introductionTextView.text = project.introduction
    }

    // MARK: - Action
    @IBAction func editIntroduction(_ sender: Any) {
        
    }
}
