//
//  KeyValueViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow

struct KeyValue {
    
    let identifier = UUID().uuidString
    var key = ""
    var value = ""
    
    static var empty: KeyValue {
        return KeyValue(key: "", value: "")
    }
    
}

extension KeyValue: AnimatableModel {

    typealias Identity = String
    
    var identity: String {
        return identifier
    }
    
}

class KeyValueViewModel {
    
    private let keyValues = BehaviorRelay<[KeyValue]>(value: [.empty])
    
    var keyValueSection: Observable<AnimatableSingleSection<KeyValue>> {
        return keyValues.map { AnimatableSingleSection.create($0) }
    }
    
    func addNewKey() {
        var value = keyValues.value
        value.append(.empty)
        keyValues.accept(value)
    }
    
    func remove(by identifier: String) {
        var value = keyValues.value
        guard let index = value.firstIndex(where: { $0.identifier == identifier }) else {
            return
        }
        value.remove(at: index)
        keyValues.accept(value)
    }
}

extension KeyValueViewModel: Stepper {
    
}
