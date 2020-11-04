//
//  M80AttributedLabel+Rx.swift
//  Httper
//
//  Created by Meng Li on 2018/10/8.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

#if os(iOS) || os(tvOS)

extension Reactive where Base: M80AttributedLabel {
    
    /// Bindable sink for `text` property.
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
    
    /// Bindable sink for `attributedText` property.
    public var attributedText: Binder<NSAttributedString?> {
        return Binder(self.base) { label, text in
            label.attributedText = text
        }
    }
    
}

#endif
