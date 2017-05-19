//
//  ProfileTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 18/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutTableViewCell: UITableViewCell!
    
    let dao = DaoManager.sharedInstance
    let user = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user.type == UserTypeEmail {
            emailLabel.text = user.email
        } else {
            emailLabel.text = NSLocalizedString("sign_in_facebook", comment: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Update user name.
        nameLabel.text = user.name
        // Hide nagivation bar and tab bar.
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
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
                                                self.logout()
            })
            let cancel = UIAlertAction.init(title: NSLocalizedString("cancel_name", comment: ""),
                                            style: .cancel,
                                            handler: nil)
            alertController.addAction(logout)
            alertController.addAction(cancel)
            alertController.popoverPresentationController?.sourceView = signOutTableViewCell;
            alertController.popoverPresentationController?.sourceRect = signOutTableViewCell.bounds;
            self.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Action
    func logout() {
        clearUserDefaults()
        // Reset revision to 0 for those request entities whose revision is larger than 0.
        for request in dao.requestDao.findRevisionLargerThan(0) {
            request.revision = 0
        }
        dao.saveContext()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
