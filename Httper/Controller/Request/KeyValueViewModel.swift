//
//  KeyValueViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxFlow

struct KeyValue {
    var key = ""
    var value = ""
    
    static let empty = KeyValue(key: "", value: "")
}

class KeyValueViewModel {
    
    private let keyValues = BehaviorSubject<[KeyValue]>(value: [.empty])
    
    var keyValueSection: Observable<SingleSection<KeyValue>> {
        return keyValues.map { SingleSection.create($0) }
    }
}

extension KeyValueViewModel: Stepper {
    
}
