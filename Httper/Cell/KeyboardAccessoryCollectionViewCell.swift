//
//  KeyboardAccessoryCollectionViewCell.swift
//  Httper
//
//  Created by Meng Li on 2019/11/14.
//  Copyright © 2019 limeng. All rights reserved.
//

import RxDataSourcesSingleSection

private struct Const {
    struct remove {
        static let size = 30
        static let margin = 4
    }
}

class KeyboardAccessoryCollectionViewCell: UICollectionViewCell {

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.minus(), for: .normal)
        button.addTarget(self, action: #selector(remove), for: .touchUpInside)
        return button
    }()
    
    private lazy var characterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(removeButton)
        addSubview(characterLabel)
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        
        removeButton.snp.makeConstraints {
            $0.size.equalTo(Const.remove.size)
            $0.top.equalToSuperview().offset(Const.remove.margin)
            $0.right.equalToSuperview().offset(-Const.remove.margin)
        }
        
        characterLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    @objc private func remove() {
        didRemove?()
    }
    
    var didRemove: (() -> Void)?
    
}

extension KeyboardAccessoryCollectionViewCell: Configurable {

    typealias Model = String

    func configure(_ model: String) {
        characterLabel.text = model
    }
    
}
