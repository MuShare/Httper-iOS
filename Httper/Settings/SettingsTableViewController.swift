//
//  SettingsTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 26/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Kingfisher

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var loginOrUserinfoButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    let user = UserManager.shared
    
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
            if user.avatar != "" {
                avatarImageView.kf.setImage(with: imageURL(user.avatar))
            }
        } else {
            loginOrUserinfoButton.setTitle(R.string.localizable.sign_in_sign_up(),
                                           for: .normal)
            avatarImageView.image = R.image.signin()
            emailLabel.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide navigation bar.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        switch cell.reuseIdentifier {
        case R.reuseIdentifier.appstore.identifier:
            UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/app/httper/id1166884043")!)
        case R.reuseIdentifier.github.identifier:
            UIApplication.shared.openURL(URL.init(string: "https://github.com/lm2343635/Httper")!)
        case R.reuseIdentifier.about.identifier:
            UIApplication.shared.openURL(URL.init(string: "http://httper.mushare.cn")!)
        default:
            break
        }
    }
    
    // MARK: - Action
    @IBAction func showAvatar(_ sender: Any) {
        showProfile()
        
    }
    
    @IBAction func showUserInfo(_ sender: Any) {
        showProfile()
    }
    
    private func showProfile() {
        if user.login {
            performSegue(withIdentifier: R.segue.settingsTableViewController.profileSegue, sender: self)
        } else {
            if let loginViewController = R.storyboard.login().instantiateInitialViewController() {
                present(loginViewController, animated: true)
            }
        }
    }
}
