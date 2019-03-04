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
        static let margin: CGFloat = 10
        static let cell = "menuCell"
    }
    
    static let menus = ["Pretty", "Raw", "Preview", "Detail"]
}

class ResultViewController: BaseViewController<ResultViewModel> {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPagingKit()
        menuViewController.reloadData()
        contentViewController.reloadData()
        
        viewModel.title.bind(to: rx.title).disposed(by: disposeBag)
    }
    
    private func setupPagingKit() {
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        
        menuViewController.view.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.menu.margin)
            $0.right.equalToSuperview().offset(-Const.menu.margin)
            $0.top.equalToSuperview().offset(topPadding + Const.menu.margin)
            $0.height.equalTo(Const.menu.height)
        }
        
        contentViewController.view.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(menuViewController.view.snp.bottom).offset(Const.menu.margin)
        }
    }
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
