//
//  PingViewController.swift
//  Httper
//
//  Created by lidaye on 27/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import Reachability

fileprivate struct Const {
    struct icon {
        static let size = 30
        static let margin = 15
    }
    
    struct address {
        static let height = 40
        static let margin = 15
    }
}

class PingViewController: BaseViewController<PingViewModel> {
    
    private lazy var controlBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        
        return barButtonItem
    }()
    
    private lazy var iconImageView = UIImageView(image: R.image.global())
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Domain Name"
        textField.becomeFirstResponder()
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.register(cellType: PingTableViewCell.self)
        return tableView
    }()

    var pingService: STDPingServices?
    var items: [STDPingItem] = []
    
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = controlBarButtonItem
        view.backgroundColor = .background
        view.addSubview(iconImageView)
        view.addSubview(addressTextField)
        view.addSubview(tableView)
        createConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Stop ping service
        if pingService != nil {
            pingService?.cancel()
        }
    }
    
    private func createConstraints() {
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(Const.icon.size)
            $0.top.equalTo(view.safeArea.top).offset(Const.icon.margin)
            $0.left.equalToSuperview().offset(Const.icon.margin)
        }
        
        addressTextField.snp.makeConstraints {
            $0.height.equalTo(Const.address.height)
            $0.centerY.equalTo(iconImageView)
            $0.left.equalTo(iconImageView.snp.left).offset(Const.address.margin)
            $0.right.equalToSuperview().offset(-Const.address.margin)
        }
        
        tableView.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(addressTextField.snp.bottom).offset(Const.address.margin)
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
                print(pingItem)
                print(pingItems)
//                if pingItem?.status != STDPingStatus.finished, let items = pingItems as? [STDPingItem] {
//                    self.items = items
//                    let indexPath = IndexPath(row: self.items.count - 1, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                } else {
//                    self.pingService = nil
//                    let indexPath = IndexPath(row: self.items.count, section: 0)
//                    self.tableView.insertRows(at: [indexPath], with: .automatic)
//                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//                }
            })
        } else {
            controlBarButtonItem.image = R.image.start()
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
