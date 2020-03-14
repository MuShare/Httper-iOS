//
//  KeyboardViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/3/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxKeyboard
import RxSwift

private enum AssociatedKeys {
    static var currentTextFieldFrame = "KeyboardViewModel.currentTextFieldFrame"
}

protocol KeyboardViewModel {
    var textFieldBottom: Observable<CGFloat> { get }
}

extension KeyboardViewModel {
    
    var viewOffset: Observable<CGFloat> {
        return Observable.combineLatest(
            RxKeyboard.instance.visibleHeight.skip(1).asObservable(),
            textFieldBottom
        ).map { keyboardHeight,textFieldBottom in
            return UIScreen.main.bounds.height - textFieldBottom - keyboardHeight
        }
    }
    
}
