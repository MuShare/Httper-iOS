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

class WhoisViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var resultWebView: UIWebView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    
    let reachability = Reachability()!
    var css = "<style>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            if let cssURL = R.file.whoisCss() {
                css += try String(contentsOf: cssURL, encoding: .utf8)
            }
        } catch let error {
            print("Failed reading, Error: " + error.localizedDescription)
        }
        css += "</style>"
    }
    
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
}
