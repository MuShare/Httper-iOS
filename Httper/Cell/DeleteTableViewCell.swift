//
//  DeleteTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2018/10/29.
//  Copyright © 2018 limeng. All rights reserved.
//

import UIKit
import Reusable

class DeleteTableViewCell: UITableViewCell, Reusable {
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(UIColor(hex: 0xff6666), for: .highlighted)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
