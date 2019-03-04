//
//  ProjectsViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/7/4.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ProjectsViewController: BaseViewController<ProjectsViewModel> {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.register(cellType: ProjectTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] in
            self?.viewModel.syncProjects {
                self?.tableView.dg_stopLoading()
            }
        }, loadingView: {
            let loadingView = DGElasticPullToRefreshLoadingViewCircle()
            loadingView.tintColor = .lightGray
            return loadingView
        }())
        tableView.dg_setPullToRefreshFillColor(.navigation)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor ?? .clear)
        
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] in
            self.viewModel.pickProject(at: $0.row)
        }).disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var dataSource = TableViewSingleSectionDataSource<Project>(configureCell: { (_, tableView, indexPath, project) in
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.project = project
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topPadding)
            $0.left.right.bottom.equalToSuperview()
        }
        
        viewModel.projectSection.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

}
