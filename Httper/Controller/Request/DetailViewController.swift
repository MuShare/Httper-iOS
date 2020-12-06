//
//  DetailViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxDataSourcesSingleSection

class DetailViewController: BaseViewController<DetailViewModel> {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.backgroundColor = .clear
        tableView.register(cellType: DetailTableViewCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        return tableView
    }()
    
    private lazy var dataSource = DetailTableViewCell.tableViewSingleSectionDataSource()
    
    override func subviews() -> [UIView] {
        return [
            tableView
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.detailSection ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    override func createConstraints() {
        tableView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
    }
    
}
