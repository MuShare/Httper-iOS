//
//  KeyValueViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxCocoa
import RxSwift

private struct Const {
    struct add {
        static let height = 60
    }
    
    struct keyValue {
        static let height = 50
    }
}

class KeyValueViewController: BaseViewController<KeyValueViewModel> {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(stackView)
        return scrollView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.add_value(), for: .normal)
        button.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.addNewKey()
        }).disposed(by: disposeBag)
        return button
    }()
    
//    private lazy var dataSource = TableViewAnimatedSingleSectionDataSource<KeyValue>(configureCell: { _, tableView, indexPath, keyValue in
//        let cell = tableView.dequeueReusableCell(for: indexPath) as KeyValueTableViewCell
//        cell.keyValue = keyValue
//        cell.delegate = self
//        return cell
//    })

    override func subviews() -> [UIView] {
        return [
            scrollView,
            addButton
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.keyValues ~> rx.keyValues,
            viewModel.characters ~> rx.characters
        ]
    }
    
    override func createConstraints() {
        scrollView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.bottom.equalTo(addButton.snp.top)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(Const.add.height)
            $0.left.right.bottom.equalToSuperview()
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
//        guard let row = viewModel.index(for: identifier) else {
//            return
//        }
//        let rectInTableView = tableView.rectForRow(at: IndexPath(row: row, section: 0))
//        let rectInSuperView = tableView.convert(rectInTableView, to: view)
//        viewModel.beginEditing(at: rectInSuperView.origin.y)
    }
    
    func editingDidEnd(for identifier: String) {
        viewModel.endEditing()
    }
    
}

private extension KeyValueViewController {
    
    func updateCharacters(_ characters: [String]) {
//        (0..<tableView.numberOfRows(inSection: 0)).map {
//            IndexPath(row: $0, section: 0)
//        }.compactMap {
//            tableView.cellForRow(at: $0) as? KeyValueTableViewCell
//        }.forEach {
//            $0.updateCharacters(characters)
//        }
    }
    
    func updateKeyValues(_ keyValues: [KeyValue]) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        keyValues.map { KeyValueView(keyValue: $0) }.forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(Const.keyValue.height)
                $0.width.equalTo(scrollView.snp.width)
            }
        }
    }
    
}

extension Reactive where Base: KeyValueViewController {
    var characters: Binder<[String]> {
        Binder(base) { viewController, characters in
            viewController.updateCharacters(characters)
        }
    }
    
    var keyValues: Binder<[KeyValue]> {
        Binder(base) { viewController, keyValues in
            viewController.updateKeyValues(keyValues)
        }
    }
}
