//
//  PingViewController.swift
//  Httper
//
//  Created by lidaye on 27/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import RxDataSourcesSingleSection

fileprivate struct Const {
    struct icon {
        static let size = 30
        static let margin = 15
    }
    
    struct address {
        static let height = 40
        static let margin = 15
    }
}

class PingViewController: BaseViewController<PingViewModel> {
    
    private lazy var controlBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.rx.tap.bind { [unowned self] in
            if self.addressTextField.isFirstResponder {
                self.addressTextField.resignFirstResponder()
            }
            self.viewModel.controlPing()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()
    
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
            self.viewModel.controlPing()
        }.disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 56
        tableView.register(cellType: PingTableViewCell.self)
        return tableView
    }()
    
    private lazy var dataSource = PingTableViewCell.tableViewAnimatedSingleSectionDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = controlBarButtonItem
        view.backgroundColor = .background
        view.addSubview(iconImageView)
        view.addSubview(addressTextField)
        view.addSubview(tableView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.icon ~> controlBarButtonItem.rx.image,
            viewModel.isValidate ~> controlBarButtonItem.rx.isEnabled,
            viewModel.address <~> addressTextField.rx.text,
            viewModel.pingItemSection ~> tableView.rx.items(dataSource: dataSource),
            viewModel.update ~> tableView.rx.scrollToBottom
        ]
    }
    
    private func createConstraints() {
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(Const.icon.size)
            $0.top.equalTo(view.safeArea.top).offset(Const.icon.margin)
            $0.left.equalToSuperview().offset(Const.icon.margin)
        }
        
        addressTextField.snp.makeConstraints {
            $0.height.equalTo(Const.address.height)
            $0.centerY.equalTo(iconImageView)
            $0.left.equalTo(iconImageView.snp.right).offset(Const.address.margin)
            $0.right.equalToSuperview().offset(-Const.address.margin)
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(addressTextField.snp.bottom).offset(Const.address.margin)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
    }
 
}
