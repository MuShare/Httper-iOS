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
    static let keyboard = Selection(icon: R.image.keyboard(), title: "Keyboard Accessory")
    static let ping = Selection(icon: R.image.ping(), title: "Ping")
    static let whois = Selection(icon: R.image.domain(), title: "Whois")
    static let ip = Selection(icon: R.image.ip(), title: "What is my IP address")
    static let appstore = Selection(icon: R.image.appstore(), title: "Rate me on App Store")
    static let github = Selection(icon: R.image.github(), title: "Give me a star on Github")
    static let about = Selection(icon: R.image.about(), title: "About")
}

private enum Const {
    static let sections: [SettingsSectionModel] = [
        SettingsSectionModel(items: [.keyboard]),
        SettingsSectionModel(items: [.ping, .whois, .ip]),
        SettingsSectionModel(items: [.appstore, .github, .about])
    ]
}

class SettingsViewModel: BaseViewModel {
    
    var sections: Observable<[SettingsSectionModel]> {
        return .just(Const.sections)
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
            break
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
