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

fileprivate struct Const {
    
    static let margin: CGFloat = 16
    
    struct requestMethod {
        static let buttonWidth = 100
        static let height: CGFloat = 50
    }
    
    struct protocols {
        static let width = 90
    }
    
    struct seperator {
        static let margin = 5
    }
    
    struct url {
        static let height: CGFloat = 50
    }
    
    struct bottomButton {
        static let height = 40
    }
    
    struct menu {
        static let height: CGFloat = 40
        static let cell = "menuCell"
    }

    static let menus = ["Parameters", "Headers", "Body"]
}

class RequestViewController: BaseViewController<RequestViewModel>, RxKeyboardViewController {
    
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
        button.rx.tap.bind { [unowned self] in
            let options = self.viewModel.methods.map { DetailOption(key: $0) }
            self.openSelector(title: "Request Methods", options: options, theme: .dark)
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var protocolsSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.tintColor = .white
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 12)
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 12)
        ], for: .selected)
        if #available(iOS 13, *) {
            segmentedControl.selectedSegmentTintColor = .white
        }
        viewModel.protocols.enumerated().forEach { (index, requestProtocol) in
            segmentedControl.insertSegment(withTitle: requestProtocol, at: index, animated: false)
        }
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
        textField.attributedPlaceholder = NSAttributedString(string: "request URL", attributes: [
            .foregroundColor: UIColor.lightGray
        ])
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
        button.rx.tap.bind { [unowned self] in
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
        button.rx.tap.bind { [unowned self] in
            self.viewModel.saveToProject()
        }.disposed(by: disposeBag)
        return button
    }()
    
    private lazy var menuView = UIView()
    
    private lazy var contentView = UIView()
    
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
    
    private lazy var bottomOffSet: CGFloat = {
        if #available(iOS 11.0, *) {
            return 0
        } else {
            return 49.0
        }
    }()

    var contentViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(requestMethodLabel)
        view.addSubview(requestMethodButton)
        view.addSubview(protocolsSegmentedControl)
        view.addSubview(separatorLabel)
        view.addSubview(urlTextField)
        view.addSubview(menuView)
        view.addSubview(contentView)
        view.addSubview(saveButton)
        view.addSubview(sendButton)
        createConstraints()
        
        addChild(menuViewController, to: menuView)
        addChild(contentViewController, to: contentView)
        
        menuViewController.reloadData()
        contentViewController.reloadData()
        
        viewModel.valueOriginY = topPadding + 300
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.requestMethod ~> requestMethodButton.rx.title(for: .normal),
            viewModel.moveupHeight ~> rx.moveupHeight,
            viewModel.url <~> urlTextField.rx.text,
            viewModel.requestProtocol <~> protocolsSegmentedControl.rx.selectedSegmentIndex,
            viewModel.characters ~> urlTextField.rx.keyboardAccessoryStrings(style: .black)
        ]

    }
    
    private func createConstraints() {
        
        requestMethodButton.snp.makeConstraints {
            $0.top.equalTo(view.safeArea.top).offset(topOffSet + Const.margin)
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
            $0.right.equalToSuperview().offset(-Const.margin)
            $0.top.equalTo(requestMethodButton.snp.bottom)
            $0.height.equalTo(Const.url.height)
        }
        
        separatorLabel.snp.makeConstraints {
            $0.centerY.equalTo(urlTextField)
            $0.left.equalTo(protocolsSegmentedControl.snp.right).offset(Const.seperator.margin)
            $0.right.equalTo(urlTextField.snp.left).offset(-Const.seperator.margin)
        }
        
        protocolsSegmentedControl.snp.makeConstraints {
            $0.width.equalTo(Const.protocols.width)
            $0.centerY.equalTo(urlTextField)
            $0.left.equalToSuperview().offset(Const.margin)
        }
        
        menuView.snp.makeConstraints {
            $0.height.equalTo(Const.menu.height)
            $0.left.equalToSuperview().offset(Const.margin)
            $0.top.equalTo(urlTextField.snp.bottom).offset(Const.margin)
            $0.right.equalToSuperview().offset(-Const.margin)
        }
        
        contentView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(menuView.snp.bottom).offset(Const.margin)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top)
        }
        
        saveButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.height.equalTo(Const.bottomButton.height)
            $0.bottom.equalTo(view.safeArea.bottom).offset(-bottomOffSet - Const.margin)
            $0.right.equalTo(sendButton.snp.left).offset(-Const.margin)
        }
        
        sendButton.snp.makeConstraints {
            $0.size.equalTo(saveButton)
            $0.centerY.equalTo(saveButton)
            $0.right.equalToSuperview().offset(-Const.margin)
        }
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
        viewModel.requestMethod.accept(option.title)
    }
    
}
