//
//  ProjectTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2019/01/10.
//  Copyright © 2019 MuShare Group. All rights reserved.
//

import UIKit
import RxDataSourcesSingleSection

class ProjectTableViewCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(nameLabel)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(17)
            $0.centerY.equalToSuperview()
        }
    }

}

extension ProjectTableViewCell: Configurable {
    
    typealias Model = Project
    
    func configure(_ model: Project) {
        nameLabel.text = model.pname
    }
    
}
