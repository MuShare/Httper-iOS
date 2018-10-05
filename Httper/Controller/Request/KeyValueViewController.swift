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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.add_value(), for: .normal)
        button.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.addNewKey()
            self.tableView.scrollToBottom()
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var dataSource = TableViewAnimatedSingleSectionDataSource<KeyValue>(configureCell: { _, tableView, indexPath, keyValue in
        let cell = tableView.dequeueReusableCell(for: indexPath) as KeyValueTableViewCell
        cell.keyValue = keyValue
        cell.delegate = self
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
        
        view.addSubview(addButton)
        view.addSubview(tableView)
        createConstraints()
        
        viewModel.keyValueSection.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func createConstraints() {
        addButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(addButton.snp.top)
        }
    }
}

extension KeyValueViewController: KeyValueTableViewCellDelegate {
    
    func keyValueUpdated(_ keyValue: KeyValue) {
        viewModel.update(keyValue: keyValue)
    }
    
    func cellShouldRemoved(by identifier: String) {
        viewModel.remove(by: identifier)
    }
    
}
