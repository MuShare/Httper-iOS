//
//  UIBarButtonItem+Rx.swift
//  Httper
//
//  Created by Meng Li on 2019/04/19.
//  Copyright © 2019 MuShare. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIBarButtonItem {
    
    var image: Binder<UIImage?> {
        return Binder(self.base) { (item, image) in
            item.image = image
        }
    }
    
}
