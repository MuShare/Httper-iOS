//
//  MenuViewCell.swift
//  Httper
//
//  Created by Meng Li on 2018/09/20.
//  Copyright © 2018 limeng. All rights reserved.
//

import UIKit
import PagingKit

class MenuViewCell: PagingMenuViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.backgroundColor = isSelected ? .darkGray : .clear
        }
    }

    var title: String? {
        didSet {
            guard let title = title else {
                return
            }
            titleLabel.text = title
        }
    }
}
