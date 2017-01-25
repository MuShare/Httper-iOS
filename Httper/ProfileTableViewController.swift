//
//  ProfileTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 18/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.reuseIdentifier == nil {
            return
        }
        let identifier = cell.reuseIdentifier!
        if identifier == "logout" {
            let alertController = UIAlertController.init(title: NSLocalizedString("sign_out_title", comment: ""),
                                                         message: NSLocalizedString("sign_out_message", comment: ""),
                                                         preferredStyle: .actionSheet)
            let logout = UIAlertAction.init(title: NSLocalizedString("sign_out_title", comment: ""),
                                            style: .destructive,
                                            handler: { (action) in
                                                
            })
            let cancel = UIAlertAction.init(title: NSLocalizedString("cancel_name", comment: ""),
                                            style: .cancel,
                                            handler: nil)
            alertController.addAction(logout)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
