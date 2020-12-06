//
//  ProjectDeleteTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2018/10/29.
//  Copyright © 2018 MuShare. All rights reserved.
//

import Reusable

class ProjectDeleteTableViewCell: UITableViewCell, Reusable {
    
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.project_delete()
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .navigation
        selectionStyle = .none
        
        addSubview(deleteLabel)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        deleteLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}
