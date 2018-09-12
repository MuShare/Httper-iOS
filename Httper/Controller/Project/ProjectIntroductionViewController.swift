//
//  ProjectIntroductionViewController.swift
//  Httper
//
//  Created by Meng Li on 17/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
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
