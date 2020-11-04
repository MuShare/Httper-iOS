//
//  RxKeyboardViewController.swift
//  Httper
//
//  Created by Meng Li on 2019/04/10.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RxKeyboardViewController {}

extension Reactive where Base: UIViewController, Base: RxKeyboardViewController {
    
    var moveupHeight: Binder<CGFloat> {
        return Binder(self.base) { (view, binder) in
            let height = binder
            guard height > 0 else {
                UIView.animate(withDuration: 0.3) {
                    UIView.animate(withDuration: 0.5, animations: {
                        view.view.frame = CGRect(x: 0, y: 0, width: view.view.frame.size.width, height: view.view.frame.size.height)
                    })
                    view.view.layoutIfNeeded()
                }
                return
            }

            UIView.animate(withDuration: 0.3) {
                view.view.frame = CGRect(x: 0, y: -height, width: view.view.frame.size.width, height: view.view.frame.size.height)
                view.view.layoutIfNeeded()
            }
        }
    }
}
