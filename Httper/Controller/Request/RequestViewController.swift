//
//  RequestViewController.swift
//  Httper
//
//  Created by Meng Li on 06/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import Alamofire
import MGKeyboardAccessory
import MGSelector
import PagingKit

let protocols = ["http", "https"]

fileprivate struct Const {
    
    static let margin = 16
    
    struct requestMethod {
        static let buttonWidth = 100
        static let height = 50
    }
    
    struct protocols {
        static let width = 75
    }
    
    struct seperator {
        static let margin = 5
    }
    
    struct url {
        static let height = 50
    }
    
    struct bottomButton {
        static let height = 40
    }
    
    struct menu {
        static let height = 40
        static let cell = "menuCell"
    }

    static let menus = ["Headers", "Parameters", "Body"]
}

class RequestViewController: UIViewController {
    
    private lazy var requestMethodLabel: UILabel = {
        let label = UILabel()
        label.text = "Request Method"
        label.textColor = .white
        return label
    }()
    
    private lazy var requestMethodButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.setTitle("GET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.rx.tap.bind {
            let options = self.viewModel.methods.map { DetailOption(key: $0) }
            self.openSelector(title: "Request Methods", options: options, theme: .dark)
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var protocolsSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        viewModel.protocols.enumerated().forEach { (index, requestProtocol) in
            segmentedControl.insertSegment(withTitle: requestProtocol, at: index, animated: false)
        }
        segmentedControl.tintColor = .white
        return segmentedControl
    }()
    
    private lazy var separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "://"
        label.textColor = .white
        return label
    }()
    
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "request URL", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.textColor = .white
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Request", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.rx.tap.bind {
            self.viewModel.sendRequest()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save to Project", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var menuViewController: PagingMenuViewController = {
        let controller = PagingMenuViewController()
        controller.dataSource = self
        controller.delegate = self
        controller.register(type: MenuViewCell.self, forCellWithReuseIdentifier: Const.menu.cell)
        controller.registerFocusView(view: UIView())
        controller.view.backgroundColor = .clear
        return controller
    }()
    
    private lazy var contentViewController: PagingContentViewController = {
        let controller = PagingContentViewController()
        controller.dataSource = self
        controller.delegate = self
        controller.view.frame = view.bounds
        return controller
    }()
    
    var contentViewControllers: [UIViewController] = []
    
    var editingTextField: UITextField!
    
    let dao = DaoManager.shared
    // Customized characters of keyboard accessory.
    let characters = UserManager.shared.characters ?? []
    
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
    
    var viewModel: RequestViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(requestMethodLabel)
        view.addSubview(requestMethodButton)
        view.addSubview(protocolsSegmentedControl)
        view.addSubview(separatorLabel)
        view.addSubview(urlTextField)
        view.addSubview(saveButton)
        view.addSubview(sendButton)
        setupPagingKit()
        createConstraints()
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        
        viewModel.requestMethod.bind(to: requestMethodButton.rx.title(for: .normal)).disposed(by: disposeBag)
        
        (urlTextField.rx.text.orEmpty <-> viewModel.url).disposed(by: disposeBag)
        (protocolsSegmentedControl.rx.selectedSegmentIndex <-> viewModel.requestProtocol).disposed(by: disposeBag)
     
    }
    
    private func setupPagingKit() {
        addChild(contentViewController)
        view.insertSubview(contentViewController.view, at: 0)
        contentViewController.didMove(toParent: self)
        
        addChild(menuViewController)
        view.insertSubview(menuViewController.view, aboveSubview: contentViewController.view)
        menuViewController.didMove(toParent: self)
    }
    
    private func createConstraints() {
        requestMethodButton.snp.makeConstraints {
            $0.top.equalTo(view.safeArea.top).offset(Const.margin)
            $0.height.equalTo(Const.requestMethod.height)
            $0.width.equalTo(Const.requestMethod.buttonWidth)
            $0.right.equalToSuperview().offset(-Const.margin)
        }
        
        requestMethodLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.right.equalTo(requestMethodButton.snp.left).offset(Const.margin)
            $0.height.equalTo(requestMethodButton)
            $0.centerY.equalTo(requestMethodButton)
        }
        
        urlTextField.snp.makeConstraints {
            $0.right.equalToSuperview().offset(Const.margin)
            $0.top.equalTo(requestMethodButton.snp.bottom)
            $0.height.equalTo(Const.url.height)
        }
        
        separatorLabel.snp.makeConstraints {
            $0.centerY.equalTo(urlTextField)
            $0.left.equalTo(protocolsSegmentedControl.snp.right).offset(Const.seperator.margin)
            $0.right.equalTo(urlTextField.snp.left).offset(-Const.seperator.margin)
        }
        
        protocolsSegmentedControl.snp.makeConstraints {
            $0.centerY.equalTo(urlTextField)
            $0.left.equalToSuperview().offset(Const.margin)
            $0.width.equalTo(Const.protocols.width)
        }
        
        menuViewController.view.snp.makeConstraints {
            $0.height.equalTo(Const.menu.height)
            $0.left.equalToSuperview().offset(Const.margin)
            $0.right.equalToSuperview().offset(-Const.margin)
            $0.top.equalTo(urlTextField.snp.bottom).offset(Const.margin)
        }
        
        contentViewController.view.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(menuViewController.view.snp.bottom).offset(Const.margin)
            $0.bottom.equalTo(saveButton.snp.top)
        }
        
        saveButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.height.equalTo(Const.bottomButton.height)
            $0.bottom.equalTo(view.safeArea.bottom).offset(-Const.margin)
            $0.right.equalTo(sendButton.snp.left).offset(-Const.margin)
        }
        
        sendButton.snp.makeConstraints {
            $0.size.equalTo(saveButton)
            $0.centerY.equalTo(saveButton)
            $0.right.equalToSuperview().offset(-Const.margin)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Setup keyboard accessory.
        urlTextField.setupKeyboardAccessory(characters, barStyle: .black)
//        for cell in valueTableView.visibleCells {
//            if cell.reuseIdentifier == R.reuseIdentifier.headerIdentifier.identifier ||
//                cell.reuseIdentifier == R.reuseIdentifier.parameterIdentifier.identifier {
//                let keyTextField = cell.viewWithTag(1) as! UITextField
//                let valueTextField = cell.viewWithTag(2) as! UITextField
//                keyTextField.setupKeyboardAccessory(characters, barStyle: .black)
//                valueTextField.setupKeyboardAccessory(characters, barStyle: .black)
//            }
//        }

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
            } else {
                url = url.substring(from: url.index(url.startIndex, offsetBy: 7))
                protocolsSegmentedControl.selectedSegmentIndex = 0
            }
            urlTextField.text = url
            request = nil
//            valueTableView.reloadData()
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
                                            url: generateRequestUrl(),
                                            headers: headers,
                                            parameters: parameters,
                                            bodytype: bodyType,
                                            body: bodyData,
                                            project: saveToProject!)

            // User SyncManger to push request
            SyncManager.shared.pushLocalRequests(nil)
            
            saveToProject = nil;
        }
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.requestViewController.resultSegue.identifier:
            let destination = segue.destination as! ResultViewController
            destination.method = method
            destination.url = generateRequestUrl()
            destination.headers = headers
            destination.parameters = parameters
            destination.body = body
//        case R.segue.requestViewController.requestBodySegue.identifier:
//            let destination = segue.destination as! RequestBodyViewController
//            destination.body = body
//        case R.segue.requestViewController.requestMethodSegue.identifier:
//            if editingTextField == nil {
//                return
//            }
//            if editingTextField.isFirstResponder {
//                editingTextField.resignFirstResponder()
//            }
        default:
            break
        }
    }

    @IBAction func chooseHeaderKey(_ sender: UIButton) {
        let cell: UITableViewCell = (sender as UIView).superview?.superview as! UITableViewCell
        choosingHeaderTextFeild = cell.viewWithTag(1) as? UITextField
        self.performSegue(withIdentifier: "headerKeySegue", sender: self)
    }
    
    @IBAction func clearRequest(_ sender: Any) {
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
//            self.valueTableView.reloadData()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveRequest(_ sender: Any) {
        if !checkRequest() {
            return
        }
 
        performSegue(withIdentifier: "selectProjectSegue", sender: self)
    }
    
    //MARK: - Service
    func generateRequestUrl() -> String {
        return protocols[protocolsSegmentedControl.selectedSegmentIndex] + "://" + urlTextField.text!
    }
    
    func checkRequest() -> Bool {
        if urlTextField.text == "" {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.url_empty())
            return false
        }
        
        headers = HTTPHeaders()
        parameters = Parameters()
        /**
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
 */
        return true
    }
    
}

extension RequestViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextField = textField
        if textField == urlTextField {
            return
        }
        
        guard let cell = textField.superview?.superview else {
            return
        }
        let rect = cell.convert(cell.bounds, to: self.view)
        let y = rect.origin.y
        if let screenHeight = view.window?.frame.size.height, y > (screenHeight - keyboardHeight) {
            let offset = keyboardHeight - (screenHeight - y) + cell.frame.size.height
            UIView.animate(withDuration: 0.5) {
                self.view.frame = CGRect(x: 0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

extension RequestViewController: PagingMenuViewControllerDataSource {
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        guard let cell = viewController.dequeueReusableCell(withReuseIdentifier: Const.menu.cell, for: index) as? MenuViewCell else {
            return MenuViewCell()
        }
        cell.title = Const.menus[index]
        return cell
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return menuViewController.view.bounds.width / CGFloat(Const.menus.count)
    }
    
    var insets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return .zero
        }
    }
    
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return Const.menus.count
    }
}

extension RequestViewController: PagingContentViewControllerDataSource {
    
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return Const.menus.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return contentViewControllers[index]
    }
    
}

extension RequestViewController: PagingMenuViewControllerDelegate {
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
    
}

extension RequestViewController: PagingContentViewControllerDelegate {
    
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
    
}

extension RequestViewController: MGSelectable {
    
    func didSelect(option: MGSelectorOption) {
        viewModel.requestMethod.onNext(option.title)
    }
    
}
