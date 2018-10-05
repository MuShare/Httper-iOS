//
//  ResultViewController.swift
//  Httper
//
//  Created by Meng Li on 07/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import Alamofire
import PagingKit

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

fileprivate struct Const {
    struct menu {
        static let height = 40
        static let cell = "menuCell"
    }
    
    static let menus = ["Pretty", "Raw", "Preview", "Detail"]
}

class ResultViewController: HttperViewController {
    
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
    
    private let viewModel: ResultViewModel
    
    init(viewModel: ResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPagingKit()
        menuViewController.reloadData()
        contentViewController.reloadData()
    }
    
    private func setupPagingKit() {
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        
        menuViewController.view.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(topPadding)
            $0.height.equalTo(Const.menu.height)
        }
        
        contentViewController.view.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(menuViewController.view.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }

    //MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case R.segue.resultViewController.requestInfoSegue.identifier:
//            let destination = segue.destination as! ResponseInfoTableViewController
//            destination.response = httpURLResponse
//        default:
//            break
//        }
//    }
    

    
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
    

    
    // Send request.
    /**
    func sendRequest() {
        Alamofire.request(url,
                          method: getHTTPMethod(method: method),
                          parameters: parameters,
                          encoding: (body == nil) ? URLEncoding.default : body,
                          headers: headers)
            .response { response in
                if response.response == nil {
                    self.showAlert(title: R.string.localizable.tip_name(), content: R.string.localizable.cannot_access())
                    return
                }
                
                // Show response.
                self.httpURLResponse = response.response
                let infoBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "info"),
                                                        style: UIBarButtonItem.Style.plain,
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
 */
}


extension ResultViewController: PagingMenuViewControllerDataSource {
    
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

extension ResultViewController: PagingContentViewControllerDataSource {
    
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return Const.menus.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return contentViewControllers[index]
    }
    
}

extension ResultViewController: PagingMenuViewControllerDelegate {
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
    
}

extension ResultViewController: PagingContentViewControllerDelegate {
    
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: false)
    }
    
}
