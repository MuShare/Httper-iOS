//
//  PingViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/04/19.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSourcesSingleSection
import Reachability

extension STDPingItem: AnimatableModel {
    
    public typealias Identity = NSInteger
    
    public var identity: NSInteger {
        return icmpSequence
    }
    
}

class PingViewModel: BaseViewModel {
    
    private let reachability = try? Reachability()
    private var pingService: STDPingServices?
    
    private let pinging = BehaviorRelay<Bool>(value: false)
    private let pingItems = BehaviorRelay<[STDPingItem]>(value: [])
    
    deinit {
        pingService?.cancel()
    }

    let address = BehaviorRelay<String?>(value: nil)
    
    var title: Observable<String> {
        .just(R.string.localizable.ping_title())
    }
    
    var icon: Observable<UIImage?> {
        return pinging.map {
            return $0 ? R.image.stop() : R.image.start()
        }
    }
    
    var isValidate: Observable<Bool> {
        return address.map {
            guard let address = $0, !address.isEmpty else {
                return false
            }
            return true
        }
    }
    
    var pingItemSection: Observable<AnimatableSingleSection<STDPingItem>> {
        return pingItems.map { AnimatableSingleSection.create($0) }
    }
    
    var update: Observable<Void> {
        return pingItemSection.map { _ in }
    }
    
    func controlPing() {
        guard let reachability = reachability else {
            return
        }
        if reachability.connection == .unavailable {
            alert.onNextCustomTip(
                title: R.string.localizable.common_tip(),
                message: R.string.localizable.common_no_internet_connection()
            )
            return
        }
        guard let address = address.value, !address.isEmpty else {
            return
        }
        pinging.accept(!pinging.value)
        
        if pinging.value {
            pingService = STDPingServices.startPingAddress(address) { [weak self] in
                guard let `self` = self, let item = $0, let items = $1 as? [STDPingItem] else {
                    return
                }
                if item.status == .finished {
                    self.pingService = nil
                } else {
                    self.pingItems.accept(items)
                }
            }
        } else {
            if pingItems.value.count > 0 {
                alert.onNextCustomTip(
                    title: R.string.localizable.ping_result(),
                    message: STDPingItem.statistics(withPingItems: pingItems.value)
                )
            }
            pingService?.cancel()
        }
    }
    
}
