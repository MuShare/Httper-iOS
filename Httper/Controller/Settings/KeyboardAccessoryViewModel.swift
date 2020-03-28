//
//  KeyboardAccessoryViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/11/14.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxCocoa
import RxDataSourcesSingleSection
import RxSwift

class KeyboardAccessoryViewModel: BaseViewModel {
    
    private let charactersRelay = BehaviorRelay<[String]>(value: UserManager.shared.characters ?? [])

    var title: Observable<String> {
        .just(R.string.localizable.keyboard_accessory_title())
    }
    
    var characterSection: Observable<SingleSection<String>> {
        charactersRelay.map { SingleSection.create($0) }
    }
    
    func add(character: String?) {
        guard let character = character, !character.isEmpty else {
            alert.onNextWarning(R.string.localizable.keyboard_accessory_illegal_character())
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
        alert.onNextConfirm(R.string.localizable.keyboard_accessory_delete_character(characters[index]), onConfirm: {
            characters.remove(at: index)
            UserManager.shared.characters = characters
            self.charactersRelay.accept(characters)
        })
    }
    
}
