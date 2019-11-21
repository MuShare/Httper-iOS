//
//  IPAddressManager.swift
//  Httper
//
//  Created by Meng Li on 2019/06/28.
//  Copyright © 2019 limeng. All rights reserved.
//

import Alamofire
import Reachability
import RxAlamofire
import RxSwift
import SwiftyJSON

struct Wifi {
    var local: String
    var broadcast: String
    var gateway: String
    var netmask: String
    
    init(wifi: JSON) {
        local = wifi["local"].string.ipString
        broadcast = wifi["broadcast"].string.ipString
        gateway = wifi["gateway"].string.ipString
        netmask = wifi["netmask"].string.ipString
    }
}

struct Cellular {
    var local: String
    var netmask: String
    
    init(cellular: JSON) {
        local = cellular["local"].string.ipString
        netmask = cellular["netmask"].string.ipString
    }
}

struct Router {
    var wifi: Wifi
    var cellular: Cellular
}

struct IPAddress {
    var ipAddress: String
    var city: String
    var country: String
    var postal: String
    var timezone: String
    var latitude: Double
    var longitude: Double

    init(ip: JSON) {
        ipAddress = ip["ip"].string.ipString
        city = ip["city"].string.ipString
        country = ip["country"].string.ipString
        postal = ip["postal"].string.ipString
        timezone = ip["timezone"].string.ipString
        latitude = ip["latitude"].doubleValue
        longitude = ip["longitude"].doubleValue
    }
}

final class IPAddressManager {
    
    static let shared = IPAddressManager()
    
    private init() {}
    
    func getRouterInfo() -> Observable<Router?> {
        let info = InternetTool.getRouterInfo()
        let wifiInfo = info?.value(forKey: kTypeInfoKeyWifi) as? [String: String] ?? [:]
        let cellularInfo = info?.value(forKey: kTypeInfoKeyCellular) as? [String: String] ?? [:]
        let router = Router(
            wifi: Wifi(wifi: JSON(wifiInfo)),
            cellular: Cellular(cellular: JSON(cellularInfo))
        )
        return .just(router)
    }
    
    func getIpAddressInfo() -> Observable<IPAddress?> {
        guard let reachability = try? Reachability(), reachability.connection != .none else {
            return .just(nil)
        }
        return RxAlamofire.request(
            .get,
            "https://ipapi.co/json/",
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil
        ).responseJSON().map {
            guard let info = $0.result.value as? [String: Any] else {
                return nil
            }
            return IPAddress(ip: JSON(info))
        }
    }
    
}

private extension Optional where Wrapped == String {
    
    var ipString: String {
        return self ?? R.string.localizable.ip_address_unknown()
    }
    
}
