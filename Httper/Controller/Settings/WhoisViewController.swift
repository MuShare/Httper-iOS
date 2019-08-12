//
//  WhoisViewController.swift
//  Httper
//
//  Created by Meng Li on 30/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import Reachability

fileprivate struct Const {
    
    struct icon {
        static let size = 30
        static let margin: CGFloat = 15
    }
    
    struct address {
        static let height = 40
        static let margin = 15
    }
    
    struct line {
        static let height = 1
        static let marginTop = 15
    }
    
    struct result {
        static let marginTop = 15
    }
    
}

class WhoisViewController: BaseViewController<WhoisViewModel> {

    private lazy var searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    
    private lazy var iconImageView = UIImageView(image: R.image.global())
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Domain Name", attributes: [
            .foregroundColor: UIColor.lightGray
        ])
        textField.becomeFirstResponder()
        textField.rx.shouldReturn.bind { [unowned self] in
            textField.resignFirstResponder()
            self.viewModel.search()
        }.disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var resultWebView: UIWebView = {
        let webView = UIWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }()
    
    private lazy var loadingActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    let reachability = Reachability()!
    var css = "<style>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = searchBarButtonItem
        view.backgroundColor = .background
        view.addSubview(iconImageView)
        view.addSubview(addressTextField)
        view.addSubview(lineView)
        view.addSubview(resultWebView)
        view.addSubview(loadingActivityIndicatorView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title
        ]
        
        do {
            if let cssURL = R.file.whoisCss() {
                css += try String(contentsOf: cssURL, encoding: .utf8)
            }
        } catch let error {
            print("Failed reading, Error: " + error.localizedDescription)
        }
        css += "</style>"
    }
    
    private func createConstraints() {
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(Const.icon.size)
            $0.left.equalToSuperview().offset(Const.icon.margin)
            $0.top.equalTo(view.safeArea.top).offset(Const.icon.margin + topOffSet)
        }
        
        addressTextField.snp.makeConstraints {
            $0.height.equalTo(Const.address.height)
            $0.centerY.equalTo(iconImageView)
            $0.left.equalTo(iconImageView.snp.right).offset(Const.address.margin)
            $0.right.equalToSuperview().offset(-Const.address.margin)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(Const.line.height)
            $0.left.equalTo(iconImageView)
            $0.top.equalTo(addressTextField.snp.bottom).offset(Const.line.marginTop)
            $0.right.equalTo(addressTextField)
        }
        
        resultWebView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(addressTextField.snp.bottom).offset(Const.result.marginTop)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
    }
    
    /**
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        domainTextField.becomeFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == domainTextField {
            whois(searchBarButtonItem)
        }
        return true
    }

    // MARK: - Action
    @IBAction func whois(_ sender: UIBarButtonItem) {
        if domainTextField.isFirstResponder {
            domainTextField.resignFirstResponder()
        }
        
        //Check Internet state
        if reachability.connection == .none {
            showAlert(title: R.string.localizable.tip_name(),
                      content: R.string.localizable.not_internet_connection())
            return
        }
        
        //Get domain info.
        searchBarButtonItem.isEnabled = false
        loadingActivityIndicatorView.startAnimating()
        Alamofire.request(whoisUrl + "/whois/" + domainTextField.text!).responseString { response in
            var html = "<meta name='format-detection' content='telephone=no'/>" + self.css
            let doc = try? HTML(html: response.result.value!, encoding: .utf8)
            if let doc = doc {
                for link in doc.css(".df-block") {
                    html += link.toHTML!
                }
                self.resultWebView.loadHTMLString(html, baseURL: URL.init(string: whoisUrl))
                self.resultWebView.isHidden = false
                self.searchBarButtonItem.isEnabled = true
                self.loadingActivityIndicatorView.stopAnimating()
            }
        }
    }
 */
}
