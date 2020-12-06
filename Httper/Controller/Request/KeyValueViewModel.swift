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

enum KeyValueEditingState {
    case begin(CGFloat)
    case end
}

class KeyValueViewModel: BaseViewModel {
    
    var keyValues: [KeyValue] = []
    
    let keyValuesRelay = BehaviorRelay<[KeyValue]>(value: [.empty])
    let editingStateSubject = PublishSubject<KeyValueEditingState>()
    
    var characters: Observable<[String]> {
        keyValuesRelay.delay(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(UserManager.shared.charactersRelay)
    }
    
    func clear() {
        keyValuesRelay.accept([.empty])
    }
    /**
    let keyValuesRelay = BehaviorRelay<[KeyValue]>(value: [.empty])
    
    
    override init() {
        super.init()
        
        keyValuesRelay.skip(1).take(1).subscribe(onNext: { [unowned self] in
            for keyValue in $0 {
                self.results[keyValue.identifier] = keyValue
            }
        }).disposed(by: disposeBag)
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
    */
}
