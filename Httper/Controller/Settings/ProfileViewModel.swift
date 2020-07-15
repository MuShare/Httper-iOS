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

private extension Selection {
    static let email = Selection(icon: R.image.email(), title: UserManager.shared.displayEmail, isAccessoryHidden: true)
    static let name = Selection(icon: R.image.name(), title: UserManager.shared.name)
}

class ProfileViewModel: BaseViewModel {
    
    private let reloadRelay = PublishRelay<Void>()
    private let selections = [Selection.email, .name]
    
    var title: Observable<String> {
        .just(R.string.localizable.profile_title())
    }
    
    var section: Observable<SingleSection<Selection>> {
        reloadRelay.map { [unowned self] _ in
            self.selections
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
            .destructive(title: R.string.localizable.profile_sign_out(), action: { [unowned self] in
                UserManager.shared.logout()
                self.steps.accept(SettingsStep.profileIsComplete)
            }),
            .customCancel(title: R.string.localizable.common_cancel_name())
        )
    }
    
    func pick(at index: Int) {
        guard selections.isSafe(for: index) else {
            return
        }
        switch selections[index] {
        case .name:
            steps.accept(SettingsStep.modifyName)
        default:
            break
        }
    }
    
}
