//
//  WhoisViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 30/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import ReachabilitySwift

let baseURL = "https://www.whois.com"

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
            let cssPath = Bundle.main.path(forResource: "whois", ofType: "css")
            css += try String(contentsOfFile: cssPath!, encoding: .utf8)
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
    @IBAction func whois(_ sender: Any) {
        if domainTextField.isFirstResponder {
            domainTextField.resignFirstResponder()
        }
        
        //Check Internet state
        if reachability.currentReachabilityStatus == .notReachable {
            showAlert(title: NSLocalizedString("tip", comment: ""),
                      content: NSLocalizedString("not_internet_connection", comment: ""),
                      controller: self)
            return
        }
        
        //Get domain info.
        searchBarButtonItem.isEnabled = false
        loadingActivityIndicatorView.startAnimating()
        Alamofire.request(baseURL + "/whois/" + domainTextField.text!).responseString { response in
            var html = "<meta name='format-detection' content='telephone=no'/>" + self.css
            if let doc = HTML(html: response.result.value!, encoding: .utf8) {
                for link in doc.css(".df-block") {
                    html += link.toHTML!
                }
                self.resultWebView.loadHTMLString(html, baseURL: URL.init(string: baseURL))
                self.resultWebView.isHidden = false
                self.searchBarButtonItem.isEnabled = true
                self.loadingActivityIndicatorView.stopAnimating()
            }
        }
    }
}
