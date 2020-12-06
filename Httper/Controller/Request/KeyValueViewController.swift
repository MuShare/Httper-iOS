//
//  KeyValueViewController.swift
//  Httper
//
//  Created by Meng Li on 2020/12/6.
//  Copyright © 2020 MuShare. All rights reserved.
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
        button.addTarget(self, action: #selector(addNewKey), for: .touchUpInside)
        return button
    }()
    
    override func subviews() -> [UIView] {
        return [
            scrollView,
            addButton
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.characters ~> rx.characters,
            viewModel.keyValuesRelay.debug() ~> rx.keyValues
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
    
    @objc private func addNewKey() {
        let keyValue = KeyValue.empty
        viewModel.keyValues.insert(keyValue, at: 0)
        
        let keyValueView = KeyValueView(keyValue: keyValue)
        keyValueView.delegate = self
        keyValueView.updateCharacters(UserManager.shared.characters ?? [])
        stackView.insertArrangedSubview(keyValueView, at: 0)
        keyValueView.snp.makeConstraints {
            $0.height.equalTo(Const.keyValue.height)
            $0.width.equalTo(scrollView.snp.width)
        }
    }
    
    func setKeyValues(_ keyValues: [KeyValue]) {
        viewModel.keyValues = keyValues
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        keyValues.map { KeyValueView(keyValue: $0) }
            .forEach { [unowned self] in
                $0.delegate = self
                stackView.addArrangedSubview($0)
                $0.snp.makeConstraints {
                    $0.height.equalTo(Const.keyValue.height)
                    $0.width.equalTo(scrollView.snp.width)
                }
            }
    }
}

extension KeyValueViewController: KeyValueViewDelegate {
    func cellShouldRemoved(by identifier: String) {
        guard let index = viewModel.index(for: identifier) else {
            return
        }
        stackView.arrangedSubviews[index].removeFromSuperview()
        viewModel.keyValues.remove(at: index)
    }
    
    func keyValueUpdated(_ keyValue: KeyValue) {
        guard let index = viewModel.index(for: keyValue.identifier) else {
            return
        }
        viewModel.keyValues[index] = keyValue
    }

    func editingDidBegin(for identifier: String) {
        guard
            let index = viewModel.index(for: identifier),
            stackView.arrangedSubviews.isSafe(for: index)
        else {
            return
        } 
        let rectInSuperView = scrollView.convert(stackView.arrangedSubviews[index].frame, to: view)
        viewModel.beginEditing(at: rectInSuperView.origin.y)
    }
    
    func editingDidEnd(for identifier: String) {
        viewModel.endEditing()
    }
}


private extension KeyValueViewController {
    func updateCharacters(_ characters: [String]) {
        stackView.arrangedSubviews
            .compactMap { $0 as? KeyValueView }
            .forEach { $0.updateCharacters(characters) }
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
            viewController.setKeyValues(keyValues)
        }
    }
}
