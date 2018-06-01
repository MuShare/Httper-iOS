//
//  ResultViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 07/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire
import M80AttributedLabel

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class ResultViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var styleSegmentedControl: UISegmentedControl!
    
    var pageViewController: UIPageViewController!
    
    var prettyViewController: PrettyViewController!
    var rawViewController: RawViewController!
    var previewViewController: PreviewViewController!
    
    var method: String!, url: String!
    var headers: HTTPHeaders!
    var parameters: Parameters!
    var body: String!
    
    var httpURLResponse: HTTPURLResponse!
    
    let dao = DaoManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = self.childViewControllers.first as! UIPageViewController
        pageViewController.dataSource = self
        
        // Show loading activity idicator.
        replaceBarButtonItemWithActivityIndicator(controller: self)
        
        sendRequest()
    }

    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: PrettyViewController.self) {
            return self.rawViewController
        } else if viewController.isKind(of: RawViewController.self) {
            return self.previewViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: PreviewViewController.self) {
            return self.rawViewController
        } else if viewController.isKind(of: RawViewController.self) {
            return self.prettyViewController
        }
        return nil
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "requestInfoSegue" {
            segue.destination.setValue(httpURLResponse, forKey: "response")
        }
    }
    
    //MARK: - Action
    @IBAction func selectStyle(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case Style.pretty.rawValue:
            if self.prettyViewController != nil {
                self.pageViewController.setViewControllers([self.prettyViewController],
                                                           direction: .forward,
                                                           animated: true,
                                                           completion: nil)
            }
        case Style.raw.rawValue:
            if self.rawViewController != nil {
                self.pageViewController.setViewControllers([self.rawViewController],
                                                           direction: .forward,
                                                           animated: true,
                                                           completion: nil)
                
            }
        case Style.preview.rawValue:
            if self.prettyViewController != nil {
                self.pageViewController.setViewControllers([self.previewViewController],
                                                           direction: .forward,
                                                           animated: true,
                                                           completion: nil)
                
            }
        default:
            break
        }
    }
    
    //MARK: - Service
    func getHTTPMethod(method: String) -> HTTPMethod {
        switch method {
        case "GET":
            return HTTPMethod.get
        case "HEAD":
            return HTTPMethod.head
        case "POST":
            return HTTPMethod.post
        case "PUT":
            return HTTPMethod.put
        case "DELETE":
            return HTTPMethod.delete
        case "CONNECT":
            return HTTPMethod.connect
        case "OPTIONS":
            return HTTPMethod.options
        case "TRACE":
            return HTTPMethod.trace
        case "PATCH":
            return HTTPMethod.patch
        default:
            return HTTPMethod.get
        }
    }
    
    @objc func currentPageChanged(notification: Notification) {
        styleSegmentedControl.selectedSegmentIndex = notification.object as! Int
    }
    
    @objc func showRequestInfo() {
        self.performSegue(withIdentifier: "requestInfoSegue", sender: self)
    }
    
    // Send request.
    func sendRequest() {
        Alamofire.request(url,
                          method: getHTTPMethod(method: method),
                          parameters: parameters,
                          encoding: (body == nil) ? URLEncoding.default : body,
                          headers: headers)
            .response { response in
                if response.response == nil {
                    showAlert(title: NSLocalizedString("tip", comment: ""),
                              content: NSLocalizedString("cannot_access", comment: ""),
                              controller: self)
                    return
                }
                
                // Show response.
                self.httpURLResponse = response.response
                let infoBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "info"),
                                                        style: UIBarButtonItemStyle.plain,
                                                        target: self,
                                                        action: #selector(self.showRequestInfo))
                self.navigationItem.rightBarButtonItem = infoBarButtonItem
                
                let utf8Text = String(data: response.data!, encoding: .utf8) ?? ""
                self.prettyViewController = PrettyViewController(text: utf8Text, headers: (response.response?.allHeaderFields)!)
                self.rawViewController = RawViewController(text: utf8Text)
                self.previewViewController = PreviewViewController(text: utf8Text, url: (response.response?.url)!)
                self.pageViewController.setViewControllers([self.prettyViewController], direction: .forward, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentPageChanged(notification:)), name: NSNotification.Name(rawValue: "currentPageChanged"), object: nil)
    }
}
