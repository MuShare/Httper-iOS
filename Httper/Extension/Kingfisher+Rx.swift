//
//  Kingfisher+Rx.swift
//  Httper
//
//  Created by Meng Li on 2019/6/5.
//  Copyright © 2019 MuShare. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift

extension Reactive where Base == KingfisherWrapper<ImageView> {
    
    var image: Binder<URL?> {
        return Binder(base.base) { imageView, image in
            imageView.kf.setImage(with: image)
        }
    }
    
}

extension KingfisherWrapper: ReactiveCompatible {}
