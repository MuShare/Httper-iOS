//
//  IPAddressViewController.swift
//  Httper
//
//  Created by Meng Li on 2019/06/17.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxDataSourcesSingleSection
import UIKit

class IPAddressViewController: BaseViewController<IPAddressViewModel> {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor(hex: 0x222222)
        tableView.hideFooterView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: IPAddressHeadTableViewCell.self)
        tableView.register(cellType: IPAddressInfoTableViewCell.self)
        tableView.register(cellType: IPAddressMapTableViewCell.self)
        return tableView
    }()
    
    private lazy var dataSource = TableViewSingleSectionDataSource<IPAddressType>(configureCell: { _, tableView, indexPath, type in
        switch type {
        case .head(let head):
            let cell = tableView.dequeueReusableCell(for: indexPath) as IPAddressHeadTableViewCell
            cell.configure(head)
            return cell
        case .info(let info):
            let cell = tableView.dequeueReusableCell(for: indexPath) as IPAddressInfoTableViewCell
            cell.configure(info)
            return cell
        case .map(let location):
            let cell = tableView.dequeueReusableCell(for: indexPath) as IPAddressMapTableViewCell
            cell.configure(location)
            return cell
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(tableView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.addressTypeSection ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    private func createConstraints() {
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(view.safeArea.top)
        }
    }
    
}
