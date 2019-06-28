//
//  IPAddressTableViewController.swift
//  Httper
//
//  Created by Meng Li on 27/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
import SwiftyJSON

class IPAddressTableViewController: UITableViewController {
    
    @IBOutlet weak var publicIPLabel: UILabel!
    @IBOutlet weak var wifiLocalLabel: UILabel!
    @IBOutlet weak var wifiBroadcastLabel: UILabel!
    @IBOutlet weak var wifiGatewayLabel: UILabel!
    @IBOutlet weak var wifiNetmaskLabel: UILabel!
    @IBOutlet weak var cellularLocalLabel: UILabel!
    @IBOutlet weak var cellularNetmaskLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!

    var pingService: STDPingServices!
    var ipInfo: JSON?
    
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let routeInfo = InternetTool.getRouterInfo()

        if let wifiInfo = routeInfo?.value(forKey: kTypeInfoKeyWifi) as? [String: String] {
            let wifi = JSON(wifiInfo)
            wifiLocalLabel.text = wifi["local"].stringValue
            wifiBroadcastLabel.text = wifi["broadcast"].stringValue
            wifiGatewayLabel.text = wifi["gateway"].stringValue
            wifiNetmaskLabel.text = wifi["netmask"].stringValue
        }
        
        if let cellularInfo = routeInfo?.value(forKey: kTypeInfoKeyCellular) as? [String: String] {
            let cellular = JSON(cellularInfo)
            cellularLocalLabel.text = cellular["local"].stringValue
            cellularNetmaskLabel.text = cellular["netmask"].stringValue
        }
        
        //Check Internet state
        if reachability.connection == .none {
            self.publicIPLabel.text = R.string.localizable.not_internet_connection()
            self.publicIPLabel.isHidden = false
            self.loadingActivityIndicatorView.stopAnimating()
        } else {
            Alamofire.request("https://ipapi.co/json/").responseJSON { [weak self] response in
                guard let `self` = self, let info = response.result.value as? [String: Any] else {
                    return
                }
                let ipInfo = JSON(info)
                self.ipInfo = ipInfo
                self.publicIPLabel.text = ipInfo["ip"].stringValue
                self.publicIPLabel.isHidden = false
                self.loadingActivityIndicatorView.stopAnimating()
            }
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.ipAddressTableViewController.detailIPInfoSegue.identifier:
            let destination = segue.destination as! DetailIPInformationTableViewController
            destination.ipInfo = ipInfo
        default:
            break
        }
    }
    
}
