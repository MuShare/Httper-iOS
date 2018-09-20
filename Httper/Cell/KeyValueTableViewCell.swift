//
//  KeyValueTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 limeng. All rights reserved.
//

import UIKit
import Reusable

fileprivate struct Const {
    static let margin = 16
    
    struct remove {
        static let size = 30
    }
}

class KeyValueTableViewCell: UITableViewCell, Reusable {
    
    private lazy var keyTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "key", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.textColor = .white
        textField.backgroundColor = .clear
        return textField
    }()
    
    private lazy var keyBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var valueTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        textField.textColor = .white
        textField.backgroundColor = .clear
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
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(keyTextField)
        addSubview(keyBorderView)
        addSubview(valueTextField)
        addSubview(valueBorderView)
        addSubview(removeButton)
        createConstraints()
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
    
}
