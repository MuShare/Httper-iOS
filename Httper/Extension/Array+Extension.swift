//
//  Array+Extension.swift
//  Httper
//
//  Created by Meng Li on 2019/8/29.
//  Copyright © 2019 MuShare. All rights reserved.
//

extension Array {
    
    func isSafe(for index: Int) -> Bool {
        return 0 ..< count ~= index
    }
    
}
