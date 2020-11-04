//
//  PingTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2019/04/19.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxDataSourcesSingleSection

fileprivate struct Const {
    
    struct bytes {
        static let marginLeft = 20
        static let marginTop = 10
    }
    
    struct reqttl {
        static let marginBottom = 10
    }
    
    struct time {
        static let marginRight = 15
    }
    
}

class PingTableViewCell: UITableViewCell {
    
    private lazy var bytesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var reqttlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(bytesLabel)
        addSubview(reqttlLabel)
        addSubview(timeLabel)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        
        bytesLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.bytes.marginLeft)
            $0.top.equalToSuperview().offset(Const.bytes.marginTop)
        }
        
        reqttlLabel.snp.makeConstraints {
            $0.left.equalTo(bytesLabel)
            $0.bottom.equalToSuperview().offset(-Const.reqttl.marginBottom)
        }
        
        timeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-Const.time.marginRight)
            $0.centerY.equalToSuperview()
        }
        
    }
    
}

extension PingTableViewCell: Configurable {
    
    typealias Model = STDPingItem
    
    func configure(_ model: STDPingItem) {
        let address = (model.ipAddress == nil) ? "unknown" : model.ipAddress as String
        bytesLabel.text = "\(model.dateBytesLength) bytes from \(address)"
        reqttlLabel.text = "icmp_req = \(model.icmpSequence), ttl = \(model.timeToLive)"
        timeLabel.text = "\(String(format: "%.2f", model.timeMilliseconds))ms"
    }
    
}
