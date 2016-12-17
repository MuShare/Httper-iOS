//
//  HistoryTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 14/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    private let requestDao = RequestDao()
    private var dateFormatter = DateFormatter()
    private var requests :[Request]!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        requests = requestDao.findAll()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestIdentifier", for: indexPath)
        let urlLabel = cell.viewWithTag(1) as! UILabel
        let methodLabel = cell.viewWithTag(2) as! UILabel
        let updateLabel = cell.viewWithTag(3) as! UILabel
        let reuqest = requests[indexPath.row]
        urlLabel.text = reuqest.url
        methodLabel.text = reuqest.method
        updateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(reuqest.update)))
        return cell
    }


}
