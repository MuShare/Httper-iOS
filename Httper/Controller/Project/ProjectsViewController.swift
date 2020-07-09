//
//  ProjectsViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/7/4.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import ESPullToRefresh
import RxDataSourcesSingleSection
import RxSwift

class ProjectsViewController: BaseViewController<ProjectsViewModel> {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.register(cellType: ProjectTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        tableView.es.addPullToRefresh { [unowned self] in
            self.viewModel.syncProjects {
                tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
            }
        }
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] in
            self.viewModel.pickProject(at: $0.row)
        }).disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var dataSource = ProjectTableViewCell.tableViewSingleSectionDataSource(configureCell: { cell, _, _ in
        cell.accessoryType = .disclosureIndicator
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.syncProjects()
    }
    override func subviews() -> [UIView] {
        [tableView]
    }
    
    override func bind() -> [Disposable] {
        [
            viewModel.projectSection ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    override func createConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topPadding)
            $0.left.right.bottom.equalToSuperview()
        }
    }

}
