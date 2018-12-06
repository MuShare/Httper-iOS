//
//  HttperViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
import RxSwift
import SwipeBack

class HttperViewController: UIViewController {
    
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
    
    deinit {
        print("😀🎉🎉🎉🎉 deinit \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        guard let navigationController = navigationController else {
            return
        }
        navigationController.swipeBackEnabled = true
        
        if let index = navigationController.viewControllers.index(of: self), index > 0 {
            navigationItem.leftBarButtonItem = {
                let barButtonItem = UIBarButtonItem()
                barButtonItem.style = .plain
                barButtonItem.image = R.image.back()
                barButtonItem.rx.tap.bind {
                    navigationController.popViewController(animated: true)
                }.disposed(by: disposeBag)
                return barButtonItem
            }()
        } else {
            navigationItem.leftBarButtonItem = nil
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
    
}
