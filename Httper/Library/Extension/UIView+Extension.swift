//
//  UIView+Extension.swift
//  athene
//
//  Created by Meng Li on 2018/09/03.
//  Copyright © 2018 XFLAG. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    
    var safeArea: ConstraintBasicAttributesDSL {
        #if swift(>=3.2)
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.snp
            }
            return self.snp
        #else
            return self.snp
        #endif
    }
    
}
