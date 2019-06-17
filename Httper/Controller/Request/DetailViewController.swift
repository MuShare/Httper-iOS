//
//  DetailViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
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
    
    private lazy var dataSource = TableViewSingleSectionDataSource<DetailModel>(configureCell: { (_, tableView, indexPath, detail) in
        let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTableViewCell
        cell.detail = detail
        return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
        
        viewModel.detailSection.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
}
