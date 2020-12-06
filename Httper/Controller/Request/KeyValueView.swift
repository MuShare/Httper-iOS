//
//  KeyValueView.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 limeng. All rights reserved.
//

import MGKeyboardAccessory
import RxSwift

fileprivate struct Const {
    static let margin = 16
    
    struct remove {
        static let size = 30
    }
}

struct KeyValue {
    let identifier = UUID().uuidString
    var key = ""
    var value = ""
    
    static var empty: KeyValue {
        return KeyValue(key: "", value: "")
    }
}

protocol KeyValueViewDelegate: class {
    func cellShouldRemoved(by identifier: String)
    func keyValueUpdated(_ keyValue: KeyValue)
    func editingDidBegin(for identifier: String)
    func editingDidEnd(for identifier: String)
}

class KeyValueView: UIView {
    
    private lazy var keyTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.key_value_key_placeholder(),
            attributes: [.foregroundColor : UIColor.lightGray]
        )
        textField.text = keyValue.key
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    
    private lazy var keyBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var valueTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.key_value_value_placeholder(),
            attributes: [.foregroundColor : UIColor.lightGray]
        )
        textField.text = keyValue.value
        textField.textColor = .white
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        return textField
    }()
    
    private lazy var valueBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.delete_value(), for: .normal)
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.delegate?.cellShouldRemoved(by: self.keyValue.identifier)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    private var keyValue: KeyValue
    
    weak var delegate: KeyValueViewDelegate?
    
    init(keyValue: KeyValue) {
        self.keyValue = keyValue
        super.init(frame: .zero)

        backgroundColor = .clear
        addSubview(keyTextField)
        addSubview(keyBorderView)
        addSubview(valueTextField)
        addSubview(valueBorderView)
        addSubview(removeButton)
        createConstraints()
        
        keyTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] in
            guard
                let delegate = self?.delegate,
                var keyValue = self?.keyValue,
                let value = self?.valueTextField.text
            else {
                return
            }
            keyValue.key = $0
            keyValue.value = value
            delegate.keyValueUpdated(keyValue)
        }).disposed(by: disposeBag)
        
        valueTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] in
            guard
                let delegate = self?.delegate,
                var keyValue = self?.keyValue,
                let key = self?.keyTextField.text
            else {
                return
            }
            keyValue.key = key
            keyValue.value = $0
            delegate.keyValueUpdated(keyValue)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        
        removeButton.snp.makeConstraints {
            $0.size.equalTo(Const.remove.size)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-Const.margin)
        }
        
        valueTextField.snp.makeConstraints {
            $0.left.equalTo(keyTextField.snp.right).offset(Const.margin)
            $0.right.equalTo(removeButton.snp.left).offset(-Const.margin)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        valueBorderView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(valueTextField)
            $0.centerX.equalTo(valueTextField)
            $0.bottom.equalTo(valueTextField)
        }
        
        keyTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(valueTextField.snp.width)
        }
        
        keyBorderView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(keyTextField)
            $0.centerX.equalTo(keyTextField)
            $0.bottom.equalTo(keyTextField)
        }
    }
    
    func updateCharacters(_ characters: [String]) {
        keyTextField.setupKeyboardAccessory(characters, barStyle: .black)
        valueTextField.setupKeyboardAccessory(characters, barStyle: .black)
    }
    
}

extension KeyValueView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.editingDidBegin(for: keyValue.identifier)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editingDidEnd(for: keyValue.identifier)
    }
}
