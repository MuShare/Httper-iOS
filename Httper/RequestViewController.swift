//
//  RequestViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 06/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit

let protocols: NSArray = ["http", "https"]

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var requestMethodButton: UIButton!
    @IBOutlet weak var protocolLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var valueTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    var headers = 1, parameters = 1
    var method = "GET"
    var protocolName = protocols[0]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        urlTextField.attributedPlaceholder = NSAttributedString(string: " Request URL", attributes: [NSForegroundColorAttributeName:UIColor.lightGray])
        
        sendButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        requestMethodButton.setTitle(method, for: .normal)
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? headers : parameters
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "parameterIdentifier", for: indexPath as IndexPath)
        let keyTextField = cell.viewWithTag(1) as! UITextField
        let valueTextField = cell.viewWithTag(2) as! UITextField
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
    
    @IBAction func chooseProtocol(_ sender: UISegmentedControl) {
        protocolName = protocols[sender.selectedSegmentIndex]
        protocolLabel.text = protocolName as! String + "://"
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        let headers: NSMutableDictionary = NSMutableDictionary()
        let parameters: NSMutableDictionary = NSMutableDictionary()
        for section in 0 ..< valueTableView.numberOfSections {
            for row in 0 ..< valueTableView.numberOfRows(inSection: 0) {
                let cell: UITableViewCell = valueTableView.cellForRow(at: IndexPath(row: row, section: 0))!
                let keyTextField = cell.viewWithTag(1) as! UITextField
                let valueTextField = cell.viewWithTag(2) as! UITextField
                if section == 0 {
                    headers.setValue(valueTextField.text!, forKey: keyTextField.text!)
                } else if section == 1 {
                    parameters.setValue(valueTextField.text!, forKey: keyTextField.text!)
                }
            }
        }
        print(headers)
        print(parameters)
    }
    
    @IBOutlet weak var sendRequest: UIButton!
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
