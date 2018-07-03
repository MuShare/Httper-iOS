//
//  RequestViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 06/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire
import MGKeyboardAccessory

let protocols = ["http", "https"]

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var requestMethodButton: UIButton!
    @IBOutlet weak var protocolLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var valueTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var protocolsSegmentedControl: UISegmentedControl!
    
    var editingTextField: UITextField!
    
    let dao = DaoManager.sharedInstance
    // Customized characters of keyboard accessory.
    let characters = UserManager.sharedInstance.characters!
    
    var headerCount = 1, parameterCount = 1
    var method: String = "GET"
    var headers: HTTPHeaders!
    var parameters: Parameters!
    var body: String!
    
    // Variables for choose header key.
    var choosingHeaderTextFeild: UITextField? = nil
    var choosedheaderKey = ""
    
    // Variables for loading request history.
    var request: Request?
    var headerKeys: [String] = [], headerValues: [String] = []
    var parameterKeys: [String] = [], parameterValues: [String] = []
    
    // Variables for saving request to project.
    var saveToProject: Project?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderColor = UIColor.lightGray.cgColor

        NotificationCenter.default.addObserver(self, selector: #selector(bodyChanged(notification:)), name: NSNotification.Name(rawValue: "bodyChanged"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Setup keyboard accessory.
        urlTextField.setupKeyboardAccessory(characters, barStyle: .black)
        for cell in valueTableView.visibleCells {
            if cell.reuseIdentifier == "headerIdentifier" || cell.reuseIdentifier == "parameterIdentifier" {
                let keyTextField = cell.viewWithTag(1) as! UITextField
                let valueTextField = cell.viewWithTag(2) as! UITextField
                keyTextField.setupKeyboardAccessory(characters, barStyle: .black)
                valueTextField.setupKeyboardAccessory(characters, barStyle: .black)
            }
        }
        
        // Set request method.
        requestMethodButton.setTitle(method, for: .normal)

        // Set header key.
        if choosingHeaderTextFeild != nil {
            choosingHeaderTextFeild?.text = choosedheaderKey
            choosingHeaderTextFeild = nil
        }
        
        // Reload request from history.
        if request != nil {
            method = request!.method!
            headerKeys = []
            headerValues = []
            for (key, value) in NSKeyedUnarchiver.unarchiveObject(with: request!.headers! as Data) as! HTTPHeaders {
                headerKeys.append(key)
                headerValues.append(value)
            }
            parameterKeys = []
            parameterValues = []
            for (key, value) in NSKeyedUnarchiver.unarchiveObject(with: request!.parameters! as Data) as! Parameters {
                parameterKeys.append(key)
                parameterValues.append(value as! String)
            }
            headerCount = headerKeys.count == 0 ? 1: headerKeys.count
            parameterCount = parameterKeys.count == 0 ? 1: parameterKeys.count
            body = (request!.body == nil) ? nil: String(data: request!.body! as Data, encoding: .utf8)
            
            //Set request method
            requestMethodButton.setTitle(method, for: .normal)
            //Set url
            var url = (request?.url)!
            if url.substring(to: url.index(url.startIndex, offsetBy: protocols[1].characters.count + 3)) == "\(protocols[1])://" {
                url = url.substring(from: url.index(url.startIndex, offsetBy: 8))
                protocolsSegmentedControl.selectedSegmentIndex = 1
                protocolLabel.text = "\(protocols[1])://"
            } else {
                url = url.substring(from: url.index(url.startIndex, offsetBy: 7))
                protocolsSegmentedControl.selectedSegmentIndex = 0
                protocolLabel.text = "\(protocols[0])://"
            }
            urlTextField.text = url
            request = nil
            valueTableView.reloadData()
        }
        
        // Save to project.
        if saveToProject != nil {
            //Save request and sync to server.
            let bodyType = "raw"
            let bodyData = (body == nil) ? nil : NSData.init(data: body.data(using: .utf8)!)
            _ = dao.requestDao.saveOrUpdate(rid: nil,
                                            update: nil,
                                            revision: nil,
                                            method: method,
                                            url: "\(protocolLabel.text!)\(urlTextField.text!)",
                                            headers: headers,
                                            parameters: parameters,
                                            bodytype: bodyType,
                                            body: bodyData,
                                            project: saveToProject!)

            // User SyncManger to push request
            SyncManager.sharedInstance.pushLocalRequests(nil)
            
            saveToProject = nil;
        }
        
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return headerCount
        case 1:
            return parameterCount
        default:
            return 1
        }
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
            view.backgroundColor = RGB(DesignColor.background.rawValue)
            return view
        }()
        
        //Set name
        let nameLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: headerView.bounds.size.width - headerView.bounds.size.height, height: headerView.bounds.size.height))
            label.textColor = UIColor.white
            switch section {
            case 0:
                label.text = R.string.localizable.headers()
            case 1:
                label.text = R.string.localizable.parameters()
            case 2:
                label.text = R.string.localizable.body()
            default:
                break
            }
            return label
        }()
        headerView.addSubview(nameLabel)
        
        if section < 2 {
            //Set button
            let addButton: UIButton = {
                let button = UIButton(frame: CGRect(x: tableView.bounds.size.width - 35, y: 0, width: headerView.bounds.size.height, height: headerView.bounds.size.height))
                button.setImage(R.image.add_value(), for: UIControlState.normal)
                button.tag = section
                button.addTarget(self, action: #selector(addNewValue(_:)), for: .touchUpInside)
                return button
            }()
            headerView.addSubview(addButton)
        }

        //Set line
        let lineView: UIView = {
            let view = UILabel(frame: CGRect(x: 15, y: 28, width: headerView.bounds.size.width - 15, height: 1))
            view.backgroundColor = UIColor.darkGray
            return view
        }()
        headerView.addSubview(lineView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        // Header cell
        if indexPath.section == 0 {
            //Cell is headers or parameters
            cell = tableView.dequeueReusableCell(withIdentifier: "headerIdentifier", for: indexPath)
            let keyTextField = cell.viewWithTag(1) as! UITextField
            let valueTextField = cell.viewWithTag(2) as! UITextField
            let deleteButton = cell.viewWithTag(3) as! UIButton
            keyTextField.text = ""
            valueTextField.text = ""
            deleteButton.isEnabled = true
            // Setup MGKeyboardAccessory
            keyTextField.setupKeyboardAccessory(characters, barStyle: .black)
            valueTextField.setupKeyboardAccessory(characters, barStyle: .black)
            //Set headers if it is not null
            if headerKeys.count > indexPath.row {
                keyTextField.text = headerKeys[indexPath.row]
                valueTextField.text = headerValues[indexPath.row]
            }
        }
        // Parameter cekk
        else if indexPath.section == 1 {
            //Cell is headers or parameters
            cell = tableView.dequeueReusableCell(withIdentifier: "parameterIdentifier", for: indexPath)
            let keyTextField = cell.viewWithTag(1) as! UITextField
            let valueTextField = cell.viewWithTag(2) as! UITextField
            let deleteButton = cell.viewWithTag(3) as! UIButton
            keyTextField.text = ""
            valueTextField.text = ""
            deleteButton.isEnabled = true
            // Setup MGKeyboardAccessory
            keyTextField.setupKeyboardAccessory(characters, barStyle: .black)
            valueTextField.setupKeyboardAccessory(characters, barStyle: .black)
            //Set parameters if it is not null
            if parameterKeys.count > indexPath.row {
                keyTextField.text = parameterKeys[indexPath.row]
                valueTextField.text = parameterValues[indexPath.row]
            }
        }
        // Body cell
        else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "bodyIdentifier", for: indexPath)
        }
        return cell
    }
    
    //MARK: - UITextViewDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
        if textField == urlTextField {
            return
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.requestViewController.resultSegue.identifier:
            let destination = segue.destination as! ResultViewController
            destination.method = method
            destination.url = "\(protocolLabel.text!)\(urlTextField.text!)"
            destination.headers = headers
            destination.parameters = parameters
            destination.body = body
        case R.segue.requestViewController.requestBodySegue.identifier:
            let destination = segue.destination as! RequestBodyViewController
            destination.body = body
        case R.segue.requestViewController.requestMethodSegue.identifier:
            if editingTextField == nil {
                return
            }
            if editingTextField.isFirstResponder {
                editingTextField.resignFirstResponder()
            }
        default:
            break
        }
    }
    
    //MARK: - Action
    @IBAction func deleteValue(_ sender: UIButton) {
        sender.isEnabled = false;
        let cell: UITableViewCell = (sender as UIView).superview?.superview as! UITableViewCell
        let indexPath = valueTableView.indexPath(for: cell)!
        if indexPath.section == 0 && headerCount > 1 {
            headerCount -= 1
            valueTableView.deleteRows(at: [indexPath], with: .automatic)
            if headerKeys.count > indexPath.row {
                headerKeys.remove(at: indexPath.row)
                headerValues.remove(at: indexPath.row)
            }
        } else if indexPath.section == 1 && parameterCount > 1 {
            parameterCount -= 1
            valueTableView.deleteRows(at: [indexPath], with: .automatic)
            if parameterKeys.count > indexPath.row {
                parameterKeys.remove(at: indexPath.row)
                parameterValues.remove(at: indexPath.row)
            }
        } else {
            let keyTextField = cell.viewWithTag(1) as! UITextField
            let valueTextField = cell.viewWithTag(2) as! UITextField
            keyTextField.text = ""
            valueTextField.text = ""
            sender.isEnabled = true
        }
    }
    
    @IBAction func chooseHeaderKey(_ sender: UIButton) {
        let cell: UITableViewCell = (sender as UIView).superview?.superview as! UITableViewCell
        choosingHeaderTextFeild = cell.viewWithTag(1) as? UITextField
        self.performSegue(withIdentifier: "headerKeySegue", sender: self)
    }
    
    @IBAction func chooseProtocol(_ sender: UISegmentedControl) {
        let protocolName = protocols[sender.selectedSegmentIndex]
        protocolLabel.text = "\(protocolName)://"
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        if checkRequest() {
            self.performSegue(withIdentifier: "resultSegue", sender: self)
        }
    }
    
    @IBAction func celarRequest(_ sender: Any) {
        let alertController = UIAlertController(title: R.string.localizable.tip_name(),
                                                message: R.string.localizable.clear_request(),
                                                preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel_name(),
                                                style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: R.string.localizable.yes_name(),
                                                style: .destructive) { action in
            if self.editingTextField != nil {
                if self.editingTextField.isFirstResponder {
                    self.editingTextField.resignFirstResponder()
                }
            }
            self.urlTextField.text = ""
            self.headerCount = 1
            self.parameterCount = 1
            self.headerKeys = []
            self.headerValues = []
            self.parameterKeys = []
            self.parameterValues = []
            self.valueTableView.reloadData()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveRequest(_ sender: Any) {
        if checkRequest() {
            self.performSegue(withIdentifier: "selectProjectSegue", sender: self)
        }
    }
    
    //MARK: - Service
    func checkRequest() -> Bool {
        if urlTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.url_empty())
            return false
        }
        
        headers = HTTPHeaders()
        parameters = Parameters()
        for section in 0 ..< 2 {
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
        return true
    }
    
    @objc func addNewValue(_ sender: AnyObject?) {
        /**
        Remove the limitation of header count and parameter count.
        if headerCount + parameterCount == 7 {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.value_max(),
                      controller: self)
            return
        }
        */
        let section: Int! = sender?.tag
        let indexPath = IndexPath(row: (section == 0) ? headerCount: parameterCount, section: section)
        if section == 0 {
            headerCount += 1
        } else if section == 1 {
            parameterCount += 1
        }
        valueTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func bodyChanged(notification: Notification) {
        body = notification.object as! String
    }

}
