//
//  RequestMethodsTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 07/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

let methods = ["GET", "POST", "HEAD", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]

class RequestMethodsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.hideFooterView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "methodIdentifier", for: indexPath as IndexPath)
        let methodLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let introductionLabel = cell.viewWithTag(2) as! UILabel
        methodLabel.text = methods[indexPath.row] 
        introductionLabel.text = NSLocalizedString(methodLabel.text!, comment: "")
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainController = self.navigationController?.viewControllers[0] as! MainViewController
        if let controller = mainController.selectedViewController, controller.isKind(of: RequestViewController.self) {
            let requestViewController = controller as! RequestViewController
            requestViewController.method = methods[indexPath.row]
            navigationController?.popViewController(animated: true)
        }
    }

}
