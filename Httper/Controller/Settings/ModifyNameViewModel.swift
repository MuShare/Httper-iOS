//
//  ModifyNameViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/2/10.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift

class ModifyNameViewModel: BaseViewModel {
    
    let name = BehaviorRelay<String?>(value: UserManager.shared.name)
    
    var title: Observable<String> {
        .just(R.string.localizable.modify_name_title())
    }
    
    var isSaveEnabled: Observable<Bool> {
        name.map {
            guard let name = $0 else {
                return false
            }
            return !name.isEmpty
        }
    }
    
    func save() {
        guard let name = name.value, !name.isEmpty else {
            alert.onNextError(R.string.localizable.modify_name_empty_name())
            return
        }
        loading.onNext(true)
        UserManager.shared.modifyName(name) { [weak self] success, tip in
            guard let `self` = self else {
                return
            }
            self.loading.onNext(false)
            guard success else {
                self.alert.onNextTip(tip ?? R.string.localizable.error_unknown())
                return
            }
            self.steps.accept(SettingsStep.modifyNameIsComplete)
        }
    }
    
}
