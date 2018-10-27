//
//  RequestTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2018/10/25.
//  Copyright © 2018 limeng. All rights reserved.
//

import UIKit
import Reusable

fileprivate struct Const {
    static let margin = 17
}

class RequestTableViewCell: UITableViewCell, Reusable {
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var methodLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(urlLabel)
        addSubview(methodLabel)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        urlLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.right.equalToSuperview().offset(-Const.margin)
            $0.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        methodLabel.snp.makeConstraints {
            $0.left.right.equalTo(urlLabel)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(urlLabel.snp.bottom)
        }
    }
    
    var request: Request? {
        didSet {
            guard let request = request else {
                return
            }
            urlLabel.text = request.url
            methodLabel.text = request.method
        }
    }
    
}
