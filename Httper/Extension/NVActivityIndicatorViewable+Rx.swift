//
//  NVActivityIndicatorViewable+Rx.swift
//  Rinrin
//
//  Created by Meng Li on 2018/12/06.
//  Copyright © 2018 MuShare. All rights reserved.
//

#if os(iOS)

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

extension Reactive where Base: UIViewController, Base: NVActivityIndicatorViewable {
    
    public var nvActivityIndicatorAnimating: Binder<Bool> {
        return Binder(self.base) { viewController, animating in
            if animating {
                viewController.startAnimating()
            } else {
                viewController.stopAnimating()
            }
        }
    }
    
}

#endif
