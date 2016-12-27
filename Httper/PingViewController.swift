//
//  PingViewController.swift
//  Httper
//
//  Created by lidaye on 27/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class PingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var controlBarButtonItem: UIBarButtonItem!

    var pinging = false
    var pingService: STDPingServices?
    var items: Array<STDPingItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Stop ping service
        if pingService != nil {
            pingService?.cancel()
        }
        
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items == nil ? 0 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pingResultIdentifier", for: indexPath)
        let bytesLabel = cell.viewWithTag(1) as! UILabel
        let reqttlLabel = cell.viewWithTag(2) as! UILabel
        let timeLabel = cell.viewWithTag(3) as! UILabel
        let item = items[indexPath.row]
        let address = (item.ipAddress == nil) ? "unknown" : item.ipAddress as String
        bytesLabel.text = "\(item.dateBytesLength) bytes from \(address)"
        reqttlLabel.text = "icmp_req = \(item.icmpSequence), ttl = \(item.timeToLive)"
        timeLabel.text = "\(String(format: "%.2f", item.timeMilliseconds))ms"
        
        return cell
    }
    
    // MARK: - Action
    @IBAction func startPing(_ sender: Any) {
        if addressTextField.text == "" {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("address_empty", comment: ""),
                      controller: self)
            return
        }
        if pinging {
            controlBarButtonItem.image = UIImage.init(named: "start")
            pingService?.cancel()
        } else {
            if items != nil {
                items = nil
                tableView.reloadData()
            }
            controlBarButtonItem.image = UIImage.init(named: "stop")
            pingService = STDPingServices.startPingAddress("fczm.pw", callbackHandler: { pingItem, pingItems in
                if pingItem?.status != STDPingStatus.finished {
                    self.items = pingItems as! Array<STDPingItem>!
                    if self.items != nil {
                        let indexPath = IndexPath(row: self.items.count - 1, section: 0)
                        self.tableView.insertRows(at: [indexPath], with: .automatic)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                } else {
                    print(STDPingItem.statistics(withPingItems: pingItems))
                    self.pingService = nil
                }
            })
        }
        pinging = !pinging
    }

}
