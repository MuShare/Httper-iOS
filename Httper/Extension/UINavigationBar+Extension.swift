//
//  UINavigationBar+Extension.swift
//  athene
//
//  Created by Meng Li on 2018/08/20.
//  Copyright © 2018 XFLAG. All rights reserved.
//

import UIKit

fileprivate struct AssociatedKeys {
    static var barColor = "barColor"
}

extension UINavigationBar {
    
    @IBInspectable public var barColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.barColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if let color = newValue {
                if color.cgColor.alpha == 0 {
                    setBackgroundImage(UIImage(), for: .default)
                } else {
                    setBackgroundImage(UIImage.image(with: color), for: .default)
                }
                
            } else {
                setBackgroundImage(nil, for: .default)
            }
        }
        
        get {
            guard let color = objc_getAssociatedObject(self, &AssociatedKeys.barColor) as? UIColor else {
                return nil
            }
            return color
        }
        
    }
    
}
