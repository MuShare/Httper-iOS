//
//  Observable+Extension.swift
//  Rinrin
//
//  Created by Meng Li on 2018/12/06.
//  Copyright © 2018 XFLAG. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    /**
     Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values.
     - returns: An observable sequence of non-optional elements
     */
    
    public func unwrap<T>() -> Observable<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! }
    }
}
