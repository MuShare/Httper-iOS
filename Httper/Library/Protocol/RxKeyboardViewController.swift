//
//  RxKeyboardViewController.swift
//  Httper
//
//  Created by Meng Li on 2019/04/10.
//  Copyright © 2019 MuShare. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate struct Const {
    static let shownHeight: CGFloat = 200
}

protocol RxKeyboardViewController {}

extension Reactive where Base: UIViewController, Base: RxKeyboardViewController {
    
    var keyboardHeight: Binder<CGFloat> {
        return Binder(self.base) { (view, binder) in
            let height = binder
            guard height > Const.shownHeight else {
                UIView.animate(withDuration: 0.3) {
                    UIView.animate(withDuration: 0.5, animations: {
                        view.view.frame = CGRect(x: 0, y: 0, width: view.view.frame.size.width, height: view.view.frame.size.height)
                    })
                    view.view.layoutIfNeeded()
                }
                return
            }
            
            let offset = height - Const.shownHeight
            UIView.animate(withDuration: 0.3) {
                view.view.frame = CGRect(x: 0, y: -offset, width: view.view.frame.size.width, height: view.view.frame.size.height)
                view.view.layoutIfNeeded()
            }
        }
    }
}
