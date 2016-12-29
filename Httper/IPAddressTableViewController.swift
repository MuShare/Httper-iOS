//
//  IPAddressTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 27/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit


class IPAddressTableViewController: UITableViewController {
    
    @IBOutlet weak var publicIPLabel: UILabel!
    @IBOutlet weak var wifiLocalLabel: UILabel!
    @IBOutlet weak var wifiBroadcastLabel: UILabel!
    @IBOutlet weak var wifiGatewayLabel: UILabel!
    @IBOutlet weak var wifiNetmaskLabel: UILabel!
    @IBOutlet weak var cellularLocalLabel: UILabel!
    @IBOutlet weak var cellularNetmaskLabel: UILabel!

    var pingService: STDPingServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let routeInfo = InternetTool.getRouterInfo()
        let wifiInfo = routeInfo?.value(forKey: kTypeInfoKeyWifi)
        let cellularInfo = routeInfo?.value(forKey: kTypeInfoKeyCellular)

        if wifiInfo != nil {
            let wifi = wifiInfo as! NSDictionary
            wifiLocalLabel.text = wifi.value(forKey: "local")! as? String
            wifiBroadcastLabel.text = wifi.value(forKey: "broadcast")! as? String
            wifiGatewayLabel.text = wifi.value(forKey: "gateway")! as? String
            wifiNetmaskLabel.text = wifi.value(forKey: "netmask")! as? String
        }
        
        if cellularInfo != nil {
            let cellular = cellularInfo as! NSDictionary
            cellularLocalLabel.text = cellular.value(forKey: "local")! as? String
            cellularNetmaskLabel.text = cellular.value(forKey: "netmask")! as? String
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
