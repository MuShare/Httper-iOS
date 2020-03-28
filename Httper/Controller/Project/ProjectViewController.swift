//
//  ProjectViewController.swift
//  Httper
//
//  Created by Meng Li on 07/02/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import ESPullToRefresh
import RxDataSources

class ProjectViewController: BaseViewController<ProjectViewModel> {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.hideFooterView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .background
        tableView.register(cellType: SelectionTableViewCell.self)
        tableView.register(cellType: RequestTableViewCell.self)
        tableView.register(cellType: DeleteTableViewCell.self)
        tableView.rowHeight = 60
        tableView.es.addPullToRefresh { [unowned self] in
            self.viewModel.syncProject {
                tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: true)
            }
        }
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] in
            self.viewModel.pick(at: $0)
        }).disposed(by: disposeBag)
        tableView.rx.itemDeleted.subscribe(onNext: { [unowned self] in
            self.viewModel.deleteRequest(at: $0.row)
        }).disposed(by: disposeBag)
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ProjectSectionModel>(configureCell: { (dataSource, tableView, indexPath, item) in
        switch dataSource[indexPath] {
        case .selectionItem(let selection):
            let cell = tableView.dequeueReusableCell(for: indexPath) as SelectionTableViewCell
            cell.configure(selection)
            return cell
        case .requestItem(let request):
            let cell = tableView.dequeueReusableCell(for: indexPath) as RequestTableViewCell
            cell.request = request
            return cell
        case .deleteItem:
            return tableView.dequeueReusableCell(for: indexPath) as DeleteTableViewCell
        }
    }, titleForHeaderInSection: { (_, _) in
        return " "
    }, canEditRowAtIndexPath: { (_, indexPath) -> Bool in
        return indexPath.section == 1
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        view.addSubview(tableView)
        createConstraints()
        
        disposeBag ~ [
            viewModel.title ~> rx.title,
            viewModel.sections ~> tableView.rx.items(dataSource: dataSource)
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.syncProject()
    }
    
    private func createConstraints() {
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(topPadding)
        }
    }

}

extension ProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
    }
    
}
