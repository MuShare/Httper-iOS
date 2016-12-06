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
    
    var headers = 1
    var parameters = 1
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        urlTextField.attributedPlaceholder = NSAttributedString(string: " Request URL", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? headers : parameters
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
            let button = UIButton(frame: CGRect(x: tableView.bounds.size.width - 35, y: 0, width: headerView.bounds.size.height, height: headerView.bounds.size.height))
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
    
    //MARK: - Action
    @IBAction func deleteValue(_ sender: Any) {
        let cell: UITableViewCell = (sender as! UIView).superview?.superview as! UITableViewCell
        let indexPath = valueTableView.indexPath(for: cell)
        if indexPath?.section == 0 {
            if headers > 1 {
                headers -= 1
                valueTableView.deleteRows(at: [indexPath!], with: .automatic)
            }
        } else if indexPath?.section == 1 {
            if parameters > 1 {
                parameters -= 1
                valueTableView.deleteRows(at: [indexPath!], with: .automatic)
            }
        }
    }
    
    //MARK: - Service
    func addNewValue(_ sender: AnyObject?) {
        let section: Int! = sender?.tag
        let indexPath = IndexPath(row: (section == 0) ? headers: parameters, section: section)
        if section == 0 {
            headers += 1
        } else if section == 1 {
            parameters += 1
        }
        valueTableView.insertRows(at: [indexPath], with: .automatic)
    }

}
