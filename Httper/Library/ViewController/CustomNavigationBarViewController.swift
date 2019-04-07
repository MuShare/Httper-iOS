//
//  CustomNavigationBarViewController.swift
//  Rinrin
//
//  Created by Meng Li on 2019/02/04.
//  Copyright © 2019 MuShare. All rights reserved.
//

import UIKit
import SwipeBack

class CustomNavigationBarViewController: UIViewController {
    
    var lastBarTintColor: UIColor? = nil
    var currentBarColor: UIColor? = nil {
        didSet {
            lastBarTintColor = navigationController?.navigationBar.barTintColor
        }
    }
    
    var isNavigationBarHidden: Bool = false {
        didSet {
            navigationController?.isNavigationBarHidden = isNavigationBarHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = navigationController {
            navigationController.swipeBackEnabled = true
            
            if let index = navigationController.viewControllers.firstIndex(of: self), index > 0 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: R.image.back(), style: .plain, target: self, action: #selector(back))
            } else {
                navigationItem.leftBarButtonItem = nil
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else {
            return
        }
        if navigationController.isNavigationBarHidden != isNavigationBarHidden {
            navigationController.isNavigationBarHidden = isNavigationBarHidden
        }
        
        if let color = currentBarColor {
            navigationController.navigationBar.barColor = color
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let color = lastBarTintColor {
            navigationController?.navigationBar.barColor = nil
            navigationController?.navigationBar.barTintColor = color
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
}
