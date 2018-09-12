//
//  RequestMethodsTableViewController.swift
//  Httper
//
//  Created by Meng Li on 07/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit

class RequestMethodsTableViewController: UITableViewController {
    
    private struct Const {
        static let methods = ["GET", "POST", "HEAD", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.hideFooterView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Const.methods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "methodIdentifier", for: indexPath as IndexPath)
        let methodLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let introductionLabel = cell.viewWithTag(2) as! UILabel
        methodLabel.text = Const.methods[indexPath.row]
        introductionLabel.text = NSLocalizedString(methodLabel.text!, comment: "")
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainController = self.navigationController?.viewControllers[0] as! MainViewController
        if let controller = mainController.selectedViewController, controller.isKind(of: RequestViewController.self) {
            let requestViewController = controller as! RequestViewController
            requestViewController.method = Const.methods[indexPath.row]
            navigationController?.popViewController(animated: true)
        }
    }

}
