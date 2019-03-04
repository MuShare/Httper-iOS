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
    var ipInfo: Dictionary<String, Any>!
    
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let routeInfo = InternetTool.getRouterInfo()

        

        if let wifiInfo = routeInfo?.value(forKey: kTypeInfoKeyWifi) {
            let wifi = wifiInfo as! [String: String]
            wifiLocalLabel.text = wifi["local"]
            wifiBroadcastLabel.text = wifi["broadcast"]
            wifiGatewayLabel.text = wifi["gateway"]
            wifiNetmaskLabel.text = wifi["netmask"]
        }
        
        if let cellularInfo = routeInfo?.value(forKey: kTypeInfoKeyCellular) {
            let cellular = cellularInfo as! [String: String]
            cellularLocalLabel.text = cellular["local"]
            cellularNetmaskLabel.text = cellular["netmask"]
        }
        
        //Check Internet state
        if reachability.connection == .none {
            self.publicIPLabel.text = R.string.localizable.not_internet_connection()
            self.publicIPLabel.isHidden = false
            self.loadingActivityIndicatorView.stopAnimating()
        } else {
            Alamofire.request(ipInfoUrl).responseJSON { response in
                self.ipInfo = response.result.value as! Dictionary<String, Any>?
                
                if (self.ipInfo["ip"] != nil) {
                    self.publicIPLabel.text = self.ipInfo["ip"]! as? String
                }
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
