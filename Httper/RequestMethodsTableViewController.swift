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

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "methodIdentifier", for: indexPath as IndexPath)
        let methodLabel: UILabel = cell.viewWithTag(1) as! UILabel
        let introductionLabel = cell.viewWithTag(2) as! UILabel
        methodLabel.text = methods[indexPath.row] 
        introductionLabel.text = NSLocalizedString(methodLabel.text!, comment: "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let length = self.navigationController?.viewControllers.count
        let controller = self.navigationController?.viewControllers[length! - 2]
        controller?.setValue(methods[indexPath.row], forKey: "method")
        _ = self.navigationController?.popViewController(animated: true)
    }

}
