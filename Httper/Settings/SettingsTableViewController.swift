//
//  SettingsTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 26/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyUserDefaults
import BiometricAuthentication

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var loginOrUserinfoButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var protectionSwitch: UISwitch!
    @IBOutlet weak var protectionLabel: UILabel!
    @IBOutlet weak var protectionIconImgaeView: UIImageView!
    
    let user = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        protectionSwitch.isOn = Defaults[.protection] ?? false
        
        if BioMetricAuthenticator.canAuthenticate() {
            if BioMetricAuthenticator.shared.faceIDAvailable() {
                protectionLabel.text = R.string.localizable.protection_faceid()
                protectionIconImgaeView.image = R.image.faceid()
            } else {
                protectionLabel.text = R.string.localizable.protection_touchid()
                protectionIconImgaeView.image = R.image.touchid()
            }
        }
        
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
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Action
    @IBAction func showAvatar(_ sender: Any) {
        showProfile()
        
    }
    
    @IBAction func showUserInfo(_ sender: Any) {
        showProfile()
    }
    
    @IBAction func changeProtection(_ sender: UISwitch) {
        Defaults[.protection] = sender.isOn
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

extension SettingsTableViewController {
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
}
