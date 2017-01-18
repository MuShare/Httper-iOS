//
//  ProfileTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 18/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

}
