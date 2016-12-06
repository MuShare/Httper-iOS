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
    @IBOutlet weak var valueTableView: UITableView!
    
    let headers: NSMutableArray = NSMutableArray(object: ["": ""])
    let parameters: NSMutableArray = NSMutableArray(object: ["": ""])
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        urlTextField.attributedPlaceholder = NSAttributedString(string: " Request URL", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? headers.count : parameters.count
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
        let nameLabel: UILabel = {
            let lebel = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.bounds.size.width - headerView.bounds.size.height, height: headerView.bounds.size.height))
            lebel.textColor = UIColor.white
            lebel.text = (section == 0) ? "Headers" : "Parameters"
            return lebel
        }()

        //Set button
        let addButton: UIButton = {
            let button = UIButton(frame: CGRect(x: tableView.bounds.size.width - headerView.bounds.size.height, y: 0, width: headerView.bounds.size.height, height: headerView.bounds.size.height))
            button.setImage(UIImage.init(named: "add_value"), for: UIControlState.normal)
            button.tag = section
            button.addTarget(self, action: #selector(addNewValue(_:)), for: .touchUpInside)
            return button
        }()
        
        //Set line
        let lineView: UIView = {
            let view = UILabel(frame: CGRect(x: 15, y: 29, width: headerView.bounds.size.width - 15, height: 1))
            view.backgroundColor = UIColor.lightGray
            return view
        }()
        
        headerView.addSubview(nameLabel)
        headerView.addSubview(addButton)
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
    
    //MARK: - Service
    func addNewValue(_ sender: AnyObject?) {
        let section = sender?.tag
        if section == 0 {
            headers.add(["": ""])
        } else if section == 1 {
            parameters.add(["": ""])
        }
        valueTableView.reloadData()
    }

}
