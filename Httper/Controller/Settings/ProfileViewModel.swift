//
//  ProfileViewModel.swift
//  Httper
//
//  Created by Meng Li on 2020/2/4.
//  Copyright © 2020 MuShare. All rights reserved.
//

import RxCocoa
import RxDataSourcesSingleSection
import RxSwift

class ProfileViewModel: BaseViewModel {
    
    private let reloadRelay = PublishRelay<Void>()
    
    var title: Observable<String> {
        .just(R.string.localizable.profile_title())
    }
    
    var section: Observable<SingleSection<Selection>> {
        reloadRelay.map { _ in
            [
                Selection(icon: R.image.email(), title: UserManager.shared.displayEmail, isAccessoryHidden: true),
                Selection(icon: R.image.name(), title: UserManager.shared.name)
            ]
        }.map {
            SingleSection.create($0)
        }
    }
    
    func reload() {
        reloadRelay.accept(())
    }
    
    func logout(sourceView: UIView) {
        actionSheet.onNextActions(
            sourceView: sourceView,
            .destructive(title: R.string.localizable.sign_out_title(), action: { [unowned self] in
                UserManager.shared.logout()
                self.steps.accept(SettingsStep.profileIsComplete)
            }),
            .customCancel(title: R.string.localizable.common_cancel_name())
        )
    }
    
    func pick(at index: Int) {
        if index == 1 {
            steps.accept(SettingsStep.modifyName)
        }
    }
    
}
