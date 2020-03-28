//
//  PingViewController.swift
//  Httper
//
//  Created by lidaye on 27/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import RxDataSourcesSingleSection

private struct Const {
    
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
        static let marginTop = 10
    }
    
    struct table {
        static let marginTop = 10
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
        textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.ping_address_placeholder(),
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        textField.becomeFirstResponder()
        textField.rx.shouldReturn.bind { [unowned self] in
            textField.resignFirstResponder()
            self.viewModel.controlPing()
        }.disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 56
        tableView.separatorColor = .darkGray
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
        view.addSubview(lineView)
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
            $0.top.equalTo(view.safeArea.top).offset(Const.icon.margin + topOffSet)
            $0.left.equalToSuperview().offset(Const.icon.margin)
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
            $0.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(lineView.snp.bottom).offset(Const.table.marginTop)
            $0.bottom.equalToSuperview()
        }
        
    }
 
}
