//
//  KeyboardAccessoryViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/11/14.
//  Copyright © 2019 limeng. All rights reserved.
//

import RxCocoa
import RxDataSourcesSingleSection
import RxSwift

class KeyboardAccessoryViewModel: BaseViewModel {
    
    private let charactersRelay = BehaviorRelay<[String]>(value: UserManager.shared.characters ?? [])

    var title: Observable<String> {
        .just("Customized Keyboard Accessory")
    }
    
    var characterSection: Observable<SingleSection<String>> {
        charactersRelay.map { SingleSection.create($0) }
    }
    
    func add(character: String) {
        
    }
    
    func remove(at index: Int) {
        
    }
    
}
