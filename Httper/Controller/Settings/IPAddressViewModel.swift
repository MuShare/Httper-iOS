//
//  IPAddressViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/06/17.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxCocoa
import RxDataSourcesSingleSection
import RxSwift

enum IPAddressType {
    case head(IPAddressHead)
    case info(IPAddressInfo)
}

class IPAddressViewModel: BaseViewModel {
    
    private let router = IPAddressManager.shared.getRouterInfo()
    private let ip = IPAddressManager.shared.getIpAddressInfo()
    
    private var addressTypes: Observable<[IPAddressType]> {
        return Observable.combineLatest(router, ip).map {
            let (router, ip) = $0
            var types: [IPAddressType] = []
            if let router = router {
                types += [
                    .head(IPAddressHead(icon: R.image.wifi(), name: R.string.localizable.ip_address_wifi())),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_wifi_local_ip(), info: router.wifi.local)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_wifi_broadcast(), info: router.wifi.broadcast)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_wifi_gateway(), info: router.wifi.gateway)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_wifi_netmask(), info: router.wifi.netmask)),
                    .head(IPAddressHead(icon: R.image.celluar(), name: R.string.localizable.ip_address_cellular())),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_cellular_local_ip(), info: router.cellular.local)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_cellular_netmask(), info: router.cellular.netmask))
                ]
            }
            if let ip = ip {
                types += [
                    .head(IPAddressHead(icon: R.image.internet(), name: R.string.localizable.ip_address_internet())),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_public_ip(), info: ip.ipAddress)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_public_city(), info: ip.city)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_public_country(), info: ip.country)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_public_post_code(), info: ip.postal)),
                    .info(IPAddressInfo(name: R.string.localizable.ip_address_public_time_zone(), info: ip.timezone))
                ]
            }
            return types
        }
    }
    
    var title: Observable<String> {
        return .just(R.string.localizable.ip_adress_title())
    }
    
    var addressTypeSection: Observable<SingleSection<IPAddressType>> {
        return addressTypes.map { SingleSection.create($0) }
    }
    
}
