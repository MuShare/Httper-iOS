//
//  KeyboardViewController.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift

protocol KeyboardViewController: UIViewController {}

extension KeyboardViewController {
    
    func moveView(with offset: CGFloat) {
        let viewOffset = min(offset - bottomPadding, 0)
        UIView.animate(withDuration: 0.2) {
            self.view.frame = CGRect(
                origin: CGPoint(x: 0, y: viewOffset),
                size: self.view.frame.size
            )
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}

extension Reactive where Base: KeyboardViewController {
    
    var viewOffset: Binder<CGFloat> {
        return Binder(base) { viewController, offset in
            viewController.moveView(with: offset)
        }
    }
    
}
