//
//  BaseNavigationController.swift
//  Rinrin
//
//  Created by Meng Li on 2018/10/24.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
import UIGradient
import RxSwift

fileprivate struct Const {
    static let colors = [
        0x333333: 0,
        0x5a5454: 1.0
    ]
}

class BaseNavigationController: UINavigationController {
    
    private let disposeBag = DisposeBag()
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.height
    private var navigationBarHeight: CGFloat?

    lazy var barTintColor: (Bool) -> UIColor? = { [unowned self] isPortrait in
        let layer = GradientLayer(direction: .leftToRight,
                                  colors: Const.colors.keys.map { UIColor(hex: UInt32($0))},
                                  locations: Const.colors.values.map { $0 })
        if self.navigationBarHeight == nil {
            self.navigationBarHeight = self.navigationBar.frame.height
        }
        let height = self.navigationBarHeight! + (isPortrait ? self.statusBarHeight : 0)
        let frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: height))
        return UIColor.fromGradient(layer, frame: frame)
    }
    
    deinit {
        AppLog.debug("[DEINIT View Controller] \(type(of: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = barTintColor(true)     
    }
    
}
