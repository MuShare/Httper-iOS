//
//  CommonTool.swift
//  Httper
//
//  Created by lidaye on 08/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

func RGB(_ value : Int) -> UIColor {
    let r = CGFloat((value & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((value & 0x00FF00) >> 8 ) / 255.0
    let b = CGFloat((value & 0x0000FF)      ) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

func ClassByName(name : String) ->  AnyClass? {
    
    var result : AnyClass? = nil
    if let bundle = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
        let className = bundle + "." + name
        result = NSClassFromString(className)
    }
    return result
}
