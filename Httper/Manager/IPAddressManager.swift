//
//  IPAddressManager.swift
//  Httper
//
//  Created by Meng Li on 2019/06/28.
//  Copyright © 2019 limeng. All rights reserved.
//

import Alamofire
import RxSwift
import SwiftyJSON

struct WifiInfo {
    var local: String
    var broadcast: String
    var gateway: String
    var netmask: String
}

struct CellularInfo {
    var local: String
    var netmask: String
}

struct RouterInfo {
    var wifi: WifiInfo
    var cellular: CellularInfo
}

final class IPAddressManager {
    
    static let shared = IPAddressManager()
    
    private init() {}
    
    func getRouterInfo() -> Observable<RouterInfo?> {
        let info = InternetTool.getRouterInfo()
        let wifiInfo = info?.value(forKey: kTypeInfoKeyWifi) as? [String: String] ?? [:]
        let cellularInfo = info?.value(forKey: kTypeInfoKeyCellular) as? [String: String] ?? [:]
        let wifi = JSON(wifiInfo)
        let cellular = JSON(cellularInfo)
        let routerInfo = RouterInfo(
            wifi: WifiInfo(
                local: wifi["local"].string.ipString,
                broadcast: wifi["broadcast"].string.ipString,
                gateway: wifi["gateway"].string.ipString,
                netmask:wifi["netmask"].string.ipString
            ),
            cellular: CellularInfo(
                local: cellular["local"].string.ipString,
                netmask: cellular["netmask"].string.ipString
            )
        )
        return .just(routerInfo)
    }
    
}

private extension Optional where Wrapped == String {
    
    var ipString: String {
        return self ?? R.string.localizable.ip_address_unknown()
    }
    
}
