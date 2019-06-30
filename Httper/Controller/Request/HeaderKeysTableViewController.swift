//
//  HeaderKeysTableViewController.swift
//  Httper
//
//  Created by Meng Li on 29/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit

class HeaderKeysTableViewController: UITableViewController {
    
    private struct Const {
        static let headerKeys = ["Accept", "Accept-Charset", "Accept-Encoding", "Accept-Language",
                                 "Accept-Datetime", "Authorization", "Cache-Control", "Connection",
                                 "Cookie", "Connection", "Content-Length", "Content-MD5", "Content-Type",
                                 "Date", "Expect", "Forwarded", "From", "Host", "If-Match", "If-Modified-Since",
                                 "If-None-Match", "If-Range", "If-Unmodified-Since", "Max-Forwards",
                                 "Origin", "Pragma", "Proxy-Authorization", "Range", "Referer",
                                 "User-Agent", "Upgrade", "Via", "Warning"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.hideFooterView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Const.headerKeys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "keyIdentifier", for: indexPath as IndexPath)
        let keyNameLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let keyDescriptionLabel = cell.viewWithTag(2) as! UILabel
        keyNameLabel.text = Const.headerKeys[indexPath.row]
        keyDescriptionLabel.text = NSLocalizedString(keyNameLabel.text!, comment: "")
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainController = self.navigationController?.viewControllers[0] as! MainViewController
        if let controller = mainController.selectedViewController, controller.isKind(of: RequestViewController.self) {
            let requestViewController = controller as! RequestViewController
//            requestViewController.choosedheaderKey = Const.headerKeys[indexPath.row]
            navigationController?.popViewController(animated: true)
        }
    }
    
}
