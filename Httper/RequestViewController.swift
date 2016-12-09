//
//  RequestViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 06/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire

let protocols = ["http", "https"]
let backgroudColor = 0x30363b, accessoryBackgroudColot = 0x1e2121
let keyboardHeight: CGFloat = 260.0

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var requestMethodButton: UIButton!
    @IBOutlet weak var protocolLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var valueTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    var headerCount = 1, parameterCount = 1
    var method: String = "GET"
    var headers: HTTPHeaders!
    var parameters: Parameters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.borderColor = UIColor.lightGray.cgColor
        setCloseKeyboardAccessoryForSender(sender: urlTextField)
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
        return (section == 0) ? headerCount : parameterCount
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
            view.backgroundColor = RGB(backgroudColor)
            return view
        }()
        
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
            let view = UILabel(frame: CGRect(x: 15, y: 28, width: headerView.bounds.size.width - 15, height: 1))
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
        setCloseKeyboardAccessoryForSender(sender: keyTextField)
        setCloseKeyboardAccessoryForSender(sender: valueTextField)
        return cell
    }
    
    //MARK: - UITextViewDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let cell = textField.superview?.superview
        let rect = cell?.convert((cell?.bounds)!, to: self.view)
        let y = (rect?.origin.y)!
        let screenHeight = (self.view.window?.frame.size.height)!
        if y > (screenHeight - keyboardHeight) {
            let offset = keyboardHeight - (screenHeight - y) + (cell?.frame.size.height)!
            UIView.animate(withDuration: 0.5, animations: {
                self.view.frame = CGRect(x: 0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultSegue" {
            segue.destination.setValue(method, forKey: "method")
            segue.destination.setValue("\(protocolLabel.text!)\(urlTextField.text!)", forKey: "url")
            segue.destination.setValue(headers, forKey: "headers")
            segue.destination.setValue(parameters, forKey: "parameters")
        }
    }
    
    //MARK: - Action
    @IBAction func deleteValue(_ sender: Any) {
        let cell: UITableViewCell = (sender as! UIView).superview?.superview as! UITableViewCell
        let indexPath = valueTableView.indexPath(for: cell)
        if indexPath?.section == 0 {
            if headerCount > 1 {
                headerCount -= 1
                valueTableView.deleteRows(at: [indexPath!], with: .automatic)
            }
        } else if indexPath?.section == 1 {
            if parameterCount > 1 {
                parameterCount -= 1
                valueTableView.deleteRows(at: [indexPath!], with: .automatic)
            }
        }
    }
    
    @IBAction func chooseProtocol(_ sender: UISegmentedControl) {
        let protocolName = protocols[sender.selectedSegmentIndex]
        protocolLabel.text = "\(protocolName)://"
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        if urlTextField.text == "" {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("url_empty", comment: ""),
                      controller: self)
            return
        }
        headers = HTTPHeaders()
        parameters = Parameters()
        for section in 0 ..< valueTableView.numberOfSections {
            for row in 0 ..< valueTableView.numberOfRows(inSection: section) {
                let cell: UITableViewCell = valueTableView.cellForRow(at: IndexPath(row: row, section: section))!
                let keyTextField = cell.viewWithTag(1) as! UITextField
                if keyTextField.text == "" {
                    continue
                }
                let valueTextField = cell.viewWithTag(2) as! UITextField
                if section == 0 {
                    headers.updateValue(valueTextField.text!, forKey: keyTextField.text!)
                } else if section == 1 {
                    parameters.updateValue(valueTextField.text!, forKey: keyTextField.text!)
                }
            }
        }
        self.performSegue(withIdentifier: "resultSegue", sender: self)
    }
    
    //MARK: - Service
    func addNewValue(_ sender: AnyObject?) {
        if headerCount + parameterCount == 7 {
            showAlert(title: NSLocalizedString("tip_name", comment: ""),
                      content: NSLocalizedString("value_max", comment: ""),
                      controller: self)
            return
        }
        let section: Int! = sender?.tag
        let indexPath = IndexPath(row: (section == 0) ? headerCount: parameterCount, section: section)
        if section == 0 {
            headerCount += 1
        } else if section == 1 {
            parameterCount += 1
        }
        valueTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func setCloseKeyboardAccessoryForSender(sender: UITextField) {
        let topView: UIToolbar = {
            let view = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 35))
            view.barStyle = .black;
            let spaceButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editFinish))
            doneButtonItem.tintColor = UIColor.white
            view.setItems([spaceButtonItem, doneButtonItem], animated: false)
            return view
        }()
        
        sender.inputAccessoryView = topView
    }
    
    func editFinish() {
        if urlTextField.isFirstResponder {
            urlTextField.resignFirstResponder()
            return
        }
        for section in 0 ..< valueTableView.numberOfSections {
            for row in 0 ..< valueTableView.numberOfRows(inSection: section) {
                let cell: UITableViewCell = valueTableView.cellForRow(at: IndexPath(row: row, section: section))!
                let keyTextField = cell.viewWithTag(1) as! UITextField
                let valueTextField = cell.viewWithTag(2) as! UITextField
                if keyTextField.isFirstResponder {
                    keyTextField.resignFirstResponder()
                    return
                }
                if valueTextField.isFirstResponder {
                    valueTextField.resignFirstResponder()
                    return
                }
            }
        }
    }
    
}
