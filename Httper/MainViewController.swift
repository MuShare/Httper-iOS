//
//  MainViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 04/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().barTintColor = UIColor (colorLiteralRed: 66.0 / 255, green: 71.0 / 255, blue: 75.0 / 255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor.white
    }

}
