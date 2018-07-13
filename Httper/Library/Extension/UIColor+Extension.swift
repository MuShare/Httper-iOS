//
//  UIColor+Extension.swift
//  xlnqclient
//
//  Created by 呉 也魯 on 2017/10/26.
//  Copyright © 2017 XFLAG, inc. All rights reserved.
//

import UIKit

extension UIColor {
    
    @objc convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = CGFloat(Int(hex >> 16) & mask) / 255
        let g = CGFloat(Int(hex >> 8) & mask) / 255
        let b = CGFloat(Int(hex) & mask) / 255
        
        self.init(red:r, green:g, blue:b, alpha:1)
    }
    
    @objc convenience init(hexa: UInt32) {
        let mask = 0x000000FF
        
        let r = CGFloat(Int(hexa >> 24) & mask) / 255
        let g = CGFloat(Int(hexa >> 16) & mask) / 255
        let b = CGFloat(Int(hexa >> 8) & mask) / 255
        let a = CGFloat(Int(hexa) & mask) / 255

        self.init(red:r, green:g, blue:b, alpha: a)
    }
    
}

