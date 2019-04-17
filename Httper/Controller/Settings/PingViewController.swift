//
//  PingViewController.swift
//  Httper
//
//  Created by lidaye on 27/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import Reachability

class PingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var controlBarButtonItem: UIBarButtonItem!

    var pingService: STDPingServices?
    var items: [STDPingItem] = []
    
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addressTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Stop ping service
        if pingService != nil {
            pingService?.cancel()
        }
    }
    
    // MARK: - Action
    @IBAction func startPing(_ sender: UITextField) {
        if addressTextField.isFirstResponder {
            addressTextField.resignFirstResponder()
        }
        
        //Check Internet state.
        if reachability.connection == .none {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.not_internet_connection())
            return
        }
        
        if addressTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.address_empty())
            return
        }
        if pingService == nil {
            if items.count > 0 {
                items = []
                tableView.reloadData()
            }
            controlBarButtonItem.image = UIImage.init(named: "stop")
            pingService = STDPingServices.startPingAddress(addressTextField.text!, callbackHandler: { [weak self] pingItem, pingItems in
                guard let `self` = self else { return }
                if pingItem?.status != STDPingStatus.finished, let items = pingItems as? [STDPingItem] {
                    self.items = items
                    let indexPath = IndexPath(row: self.items.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                } else {
                    self.pingService = nil
                    let indexPath = IndexPath(row: self.items.count, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            })
        } else {
            controlBarButtonItem.image = UIImage.init(named: "start")
            pingService?.cancel()
        }
    }

}

extension PingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            return 0
        }
        return (pingService == nil) ? items.count + 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if indexPath.row < items.count {
            cell = tableView.dequeueReusableCell(withIdentifier: "pingResultIdentifier", for: indexPath)
            let bytesLabel = cell.viewWithTag(1) as! UILabel
            let reqttlLabel = cell.viewWithTag(2) as! UILabel
            let timeLabel = cell.viewWithTag(3) as! UILabel
            let item = items[indexPath.row]
            let address = (item.ipAddress == nil) ? "unknown" : item.ipAddress as String
            bytesLabel.text = "\(item.dateBytesLength) bytes from \(address)"
            reqttlLabel.text = "icmp_req = \(item.icmpSequence), ttl = \(item.timeToLive)"
            timeLabel.text = "\(String(format: "%.2f", item.timeMilliseconds))ms"
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "pingStatisticsIdentifier", for: indexPath)
            let statisticsLabel = cell.viewWithTag(1) as! UILabel
            statisticsLabel.text = STDPingItem.statistics(withPingItems: items)
        }
        return cell
    }
    
}

extension PingViewController: UITableViewDelegate {
    
}

extension PingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addressTextField {
            startPing(addressTextField)
        }
        return true
    }
    
}
