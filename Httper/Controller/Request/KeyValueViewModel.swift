//
//  KeyValueViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSourcesSingleSection

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

enum KeyValueEditingState {
    case begin(CGFloat)
    case end
}

class KeyValueViewModel: BaseViewModel {
    
    let keyValuesRelay = BehaviorRelay<[KeyValue]>(value: [.empty])
    let editingStateSubject = PublishSubject<KeyValueEditingState>()
    
    override init() {
        super.init()
        
        keyValuesRelay.skip(1).take(1).subscribe(onNext: { [unowned self] in
            for keyValue in $0 {
                self.results[keyValue.identifier] = keyValue
            }
        }).disposed(by: disposeBag)
    }
    
    var results: [String: KeyValue] = [:]
    
    var keyValues: Observable<[KeyValue]> {
        keyValuesRelay.asObservable()
    }

    var characters: Observable<[String]> {
        keyValuesRelay.withLatestFrom(UserManager.shared.charactersRelay)
    }
    
    func addNewKey() {
        var value = keyValuesRelay.value
        value.insert(.empty, at: 0)
        keyValuesRelay.accept(value)
    }
    
    func remove(by identifier: String) {
        var value = keyValuesRelay.value
        guard let index = value.firstIndex(where: { $0.identifier == identifier }) else {
            return
        }
        value.remove(at: index)
        keyValuesRelay.accept(value)
        
        results.removeValue(forKey: identifier)
    }
    
    func update(keyValue: KeyValue) {
        results[keyValue.identifier] = keyValue
    }
    
    func index(for identifier: String) -> Int? {
        keyValuesRelay.value.firstIndex { $0.identifier == identifier }
    }
    
    func beginEditing(at height: CGFloat) {
        editingStateSubject.onNext(.begin(height))
    }
    
    func endEditing() {
        editingStateSubject.onNext(.end)
    }
    
    func clear() {
        keyValuesRelay.accept([.empty])
    }
    
}
