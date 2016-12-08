//
//  RequestMethodsTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 07/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

let methods: NSArray = ["GET", "POST", "HEAD", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]

class RequestMethodsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        methodLabel.text = methods[indexPath.row] as? String
        introductionLabel.text = NSLocalizedString(methodLabel.text!, comment: "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let length = self.navigationController?.viewControllers.count
        let controller = self.navigationController?.viewControllers[length! - 2]
        controller?.setValue(methods[indexPath.row], forKey: "method")
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
