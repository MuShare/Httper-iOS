//
//  IPAddressHeadTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2019/06/17.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxDataSourcesSingleSection
import UIKit

private struct Const {
    
    struct icon {
        static let size = 30
        static let marginTop = 10
    }
    
    struct name {
        static let marginVertical = 5
    }
    
}

class IPAddressHeadTableViewCell: UITableViewCell {
    
    private lazy var iconImageView = UIImageView()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(nameLabel)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(Const.icon.size)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Const.icon.marginTop)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(Const.name.marginVertical)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Const.name.marginVertical)
        }
        
    }
    
}

struct IPAddressHead {
    var icon: UIImage?
    var name: String
}

extension IPAddressHeadTableViewCell: Configurable {
    
    typealias Model = IPAddressHead
    
    func configure(_ model: IPAddressHead) {
        iconImageView.image = model.icon
        nameLabel.text = model.name
    }
    
}
