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

enum Style: Int {
    case pretty = 0
    case row = 1
    case preview = 2
}

class ResultViewController: UIViewController, UIPageViewControllerDataSource {
    var pageViewController: UIPageViewController!
    
    var prettyViewController: PrettyViewController!
    var rowViewController: RawViewController!
    var previewViewController: PreviewViewController!
    
    var method: String!, url: String!
    var headers: HTTPHeaders!
    var parameters: Parameters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = self.childViewControllers.first as! UIPageViewController
        pageViewController.dataSource = self
        
        Alamofire.request(url,
                          method: getHTTPMethod(method: method),
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: headers)
            .response { response in
                let utf8Text = String(data: response.data!, encoding: .utf8)
                self.prettyViewController = PrettyViewController(text: utf8Text!)
                self.rowViewController = RawViewController(text: utf8Text!)
                self.previewViewController = PreviewViewController(text: utf8Text!)
                self.pageViewController.setViewControllers([self.prettyViewController], direction: .forward, animated: true, completion: nil)
        }

    }

    //MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: PrettyViewController.self) {
            return self.rowViewController
        } else if viewController.isKind(of: RawViewController.self) {
            return self.previewViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: PreviewViewController.self) {
            return self.rowViewController
        } else if viewController.isKind(of: RawViewController.self) {
            return self.prettyViewController
        }
        return nil
    }
    
    //MARK: - Action
    @IBAction func selectStyle(_ sender: UISegmentedControl) {
        
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
    
}
