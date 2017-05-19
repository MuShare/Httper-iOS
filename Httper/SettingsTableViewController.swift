//
//  SettingsTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 26/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var loginOrUserinfoButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    let user = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if user.login {
            loginOrUserinfoButton.setTitle(user.name, for: .normal)
            if user.type == UserTypeEmail {
                emailLabel.text = user.email
                emailLabel.isHidden = false
            }
        } else {
            loginOrUserinfoButton.setTitle(NSLocalizedString("sign_in_sign_up", comment: ""),
                                           for: .normal)
            emailLabel.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide navigation bar.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        if identifier == "appstore" {
            UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/app/httper/id1166884043")!)
        } else if identifier == "github" {
            UIApplication.shared.openURL(URL.init(string: "https://github.com/lm2343635/Httper")!)
        } else if identifier == "about" {
            UIApplication.shared.openURL(URL.init(string: "http://httper.mushare.cn")!)
        }
        
    }
    
    // MARK: - Action
    @IBAction func showAvatar(_ sender: Any) {
        performSegue(withIdentifier: user.login ? "profileSegue" : "loginSegue", sender: self)
    }
    
    @IBAction func showUserInfo(_ sender: Any) {
        performSegue(withIdentifier: user.login ? "profileSegue" : "loginSegue", sender: self)
    }
    
}
