//
//  KeyValueViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSourcesSingleSection

private struct Const {
    struct add {
        static let height = 60
    }
}

class KeyValueViewController: BaseViewController<KeyValueViewModel> {
    
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

    override func subviews() -> [UIView] {
        return [
            addButton,
            tableView
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.keyValueSection ~> tableView.rx.items(dataSource: dataSource),
            viewModel.characters ~> rx.characters
        ]
    }
    
    override func createConstraints() {
        addButton.snp.makeConstraints {
            $0.height.equalTo(Const.add.height)
            $0.left.right.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
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
    
    func editingDidBegin(for identifier: String) {
        guard let row = viewModel.index(for: identifier) else {
            return
        }
        let rectInTableView = tableView.rectForRow(at: IndexPath(row: row, section: 0))
        let rectInSuperView = tableView.convert(rectInTableView, to: view)
        viewModel.beginEditing(at: rectInSuperView.origin.y)
    }
    
    func editingDidEnd(for identifier: String) {
        viewModel.endEditing()
    }
    
}

private extension KeyValueViewController {
    
    func updateCharacters(_ characters: [String]) {
        (0..<tableView.numberOfRows(inSection: 0)).map {
            IndexPath(row: $0, section: 0)
        }.compactMap {
            tableView.cellForRow(at: $0) as? KeyValueTableViewCell
        }.forEach {
            $0.updateCharacters(characters)
        }
    }
    
}

extension Reactive where Base: KeyValueViewController {
    
    var characters: Binder<[String]> {
        Binder(base) { viewController, characters in
            viewController.updateCharacters(characters)
        }
    }
    
}

