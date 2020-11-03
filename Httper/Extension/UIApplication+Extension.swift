//
//  UIApplication+Extension.swift
//  Httper
//
//  Created by Meng Li on 2020/11/3.
//  Copyright © 2020 MuShare. All rights reserved.
//

extension UIApplication {
    var isProduction: Bool {
        #if DEBUG
        return false
        #elseif ADHOC
        return false
        #else
        return true
        #endif
    }
}
