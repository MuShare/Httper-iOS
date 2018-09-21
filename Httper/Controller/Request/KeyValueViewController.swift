//
//  KeyValueViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
import RxSwift

class KeyValueViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.register(cellType: KeyValueTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var dataSource = TableViewSingleSectionDataSource<KeyValue>(configureCell: { _, tableView, indexPath, keyValue in
        let cell = tableView.dequeueReusableCell(for: indexPath) as KeyValueTableViewCell
        return cell
    })
    
    private let viewModel: KeyValueViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: KeyValueViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        createConstraints()
        
        viewModel.keyValueSection.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func createConstraints() {
        tableView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
}
