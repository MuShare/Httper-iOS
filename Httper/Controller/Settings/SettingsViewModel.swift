//
//  SettingsViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/9/13.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxDataSources
import RxSwift

enum SettingsSectionItem {
    case configItem
    case menuItem
    case agreementItem
}

struct SettingsSectionModel {
    var items: [Selection]
}

extension SettingsSectionModel: SectionModelType {
    
    typealias Item = Selection
    
    init(original: SettingsSectionModel, items: [Selection]) {
        self = original
    }
    
}

extension Selection {
    static let keyboard = Selection(icon: R.image.keyboard(), title: R.string.localizable.settings_selection_keyboard())
    static let ping = Selection(icon: R.image.ping(), title: R.string.localizable.settings_selection_ping())
    static let whois = Selection(icon: R.image.domain(), title: R.string.localizable.settings_selection_whois())
    static let ip = Selection(icon: R.image.ip(), title: R.string.localizable.settings_selection_ip())
    static let appstore = Selection(icon: R.image.appstore(), title: R.string.localizable.settings_selection_appstore())
    static let github = Selection(icon: R.image.github(), title: R.string.localizable.settings_selection_github())
    static let about = Selection(icon: R.image.about(), title: R.string.localizable.ssettings_selection_about())
}

private enum Const {
    static let sections: [SettingsSectionModel] = [
        SettingsSectionModel(items: [.keyboard]),
        SettingsSectionModel(items: [.ping, .whois, .ip]),
        SettingsSectionModel(items: [.appstore, .github, .about])
    ]
}

class SettingsViewModel: BaseViewModel {
    
    private let isLoginSubject = PublishSubject<Bool>()
    
    var avatar: Observable<URL?> {
        return isLoginSubject.distinctUntilChanged().map {
            switch UserManager.shared.type {
            case .email:
                return nil
            case .facebook:
                return $0 ? imageURL(UserManager.shared.avatar) :  nil
            }
        }
    }
    
    var name: Observable<String?> {
        return isLoginSubject.distinctUntilChanged().map {
            $0 ? UserManager.shared.name : R.string.localizable.sign_in_sign_up()
        }
    }
    
    var email: Observable<String?> {
        return isLoginSubject.distinctUntilChanged().map {
            $0 ? UserManager.shared.email : nil
        }
    }
    
    var sections: Observable<[SettingsSectionModel]> {
        return .just(Const.sections)
    }
    
    func reload() {
        isLoginSubject.onNext(UserManager.shared.login)
    }
    
    func signin() {
        if UserManager.shared.login {
            steps.accept(SettingsStep.profile)
        } else {
            steps.accept(SettingsStep.signin)
        }
    }
    
    func pick(at indexPath: IndexPath) {
        guard Const.sections.isSafe(for: indexPath.section) else {
            return
        }
        let items = Const.sections[indexPath.section].items
        guard items.isSafe(for: indexPath.row) else {
            return
        }
        let item = items[indexPath.row]
        switch item {
        case .keyboard:
            steps.accept(SettingsStep.keyboard)
        case .ping:
            steps.accept(SettingsStep.ping)
        case .whois:
            steps.accept(SettingsStep.whois)
        case .ip:
            steps.accept(SettingsStep.ip)
        case .appstore:
            if let url = URL(string: "itms-apps://itunes.apple.com/app/httper/id1166884043") {
                UIApplication.shared.open(url , options: [:])
            }
        case .github:
            if let url = URL(string: "https://github.com/lm2343635/Httper") {
                UIApplication.shared.open(url , options: [:])
            }
        case .about:
            if let url = URL(string: "http://httper.mushare.cn") {
                UIApplication.shared.open(url , options: [:])
            }
        default:
            break
        }
    }
    
}
