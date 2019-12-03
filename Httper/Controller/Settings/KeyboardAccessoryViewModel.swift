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
    
    func add(character: String?) {
        guard let character = character, !character.isEmpty else {
            alert.onNextWarning("Please input a legal character!")
            return
        }
        var characters = charactersRelay.value
        characters.append(character)
        UserManager.shared.characters = characters
        charactersRelay.accept(characters)
    }
    
    func remove(at index: Int) {
        guard charactersRelay.value.isSafe(for: index) else {
            return
        }
        var characters = charactersRelay.value
        alert.onNextConfirm("Are you sure to delete the character '\(characters[index])'?", onConfirm: {
            characters.remove(at: index)
            UserManager.shared.characters = characters
            self.charactersRelay.accept(characters)
        })
    }
    
}
