//
//  IPAddressInfoTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2019/06/17.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxDataSourcesSingleSection

private struct Const {
    static let marginHorizontal = 17
    static let marginVertical = 15
}

class IPAddressInfoTableViewCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor(hex: 0x3a3e42)
        
        addSubview(nameLabel)
        addSubview(infoLabel)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.marginHorizontal)
            $0.top.equalToSuperview().offset(Const.marginVertical)
            $0.bottom.equalToSuperview().offset(-Const.marginVertical)
        }
        
        infoLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-Const.marginHorizontal)
            $0.centerY.equalToSuperview()
        }
        
    }
    
}

struct IPAddressInfo {
    var name: String
    var info: String
}

extension IPAddressInfoTableViewCell: Configurable {
    
    typealias Model = IPAddressInfo
    
    func configure(_ model: IPAddressInfo) {
        nameLabel.text = model.name
        infoLabel.text = model.info
    }
    
}
