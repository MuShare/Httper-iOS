//
//  HttperNavigationController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 2018/9/12.
//  Copyright © 2018 limeng. All rights reserved.
//

import UIKit
import UIGradient

fileprivate struct Const {
    static let colors = [
        0x333333: 0,
        0x5a5454: 1.0
    ]
}

class HttperNavigationController: UINavigationController {
    
    lazy var barTintColor: UIColor? = {
        let layer = GradientLayer(direction: .leftToRight,
                                  colors: Const.colors.keys.map { UIColor(hex: UInt32($0))},
                                  locations: Const.colors.values.map { $0 })
        let height = navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        let frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: height))
        return UIColor.fromGradient(layer, frame: frame)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = barTintColor
        
    }
    
}
