//
//  RequestViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 06/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var requestMethodButton: UIButton!
    @IBOutlet weak var protocolLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        urlTextField.attributedPlaceholder = NSAttributedString(string: " Request URL", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        //Set name
        let nameLabel: UILabel = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.bounds.size.width - headerView.bounds.size.height, height: headerView.bounds.size.height))
        nameLabel.textColor = UIColor.white
        if section == 0 {
            nameLabel.text = "Headers"
        } else {
            nameLabel.text = "Parameters"
        }
        headerView.addSubview(nameLabel)
        //Set button
        let addButton: UIButton = UIButton(frame: CGRect(x: tableView.bounds.size.width - headerView.bounds.size.height, y: 0, width: headerView.bounds.size.height, height: headerView.bounds.size.height))
        addButton.setImage(UIImage.init(named: "add_value"), for: UIControlState.normal)
        headerView.addSubview(addButton)
        //Set line
        let lineView: UIView = UILabel(frame: CGRect(x: 15, y: 29, width: headerView.bounds.size.width - 15, height: 1))
        lineView.backgroundColor = UIColor.lightGray
        headerView.addSubview(lineView)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "parameterIdentifier", for: indexPath as IndexPath)
        let keyTextField: UITextField = cell.viewWithTag(1) as! UITextField
        let valueTextField: UITextField = cell.viewWithTag(2) as! UITextField
        keyTextField.attributedPlaceholder = NSAttributedString(string: "key", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        valueTextField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        return cell
    }
}
