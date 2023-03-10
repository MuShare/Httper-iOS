//
//  DetailTableViewCell.swift
//  Httper
//
//  Created by Meng Li on 2018/10/12.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxDataSourcesSingleSection

private struct Const {
    static let margin = 20
    
    struct title {
        static let marginTop = 5
        static let height = 17
    }
}

class DetailTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isScrollEnabled = false
        textView.contentMode = .scaleToFill
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(titleLabel)
        addSubview(contentTextView)
        createConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConstraints() {
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.right.equalToSuperview().offset(-Const.margin)
            $0.top.equalToSuperview().offset(Const.title.marginTop)
            $0.bottom.equalTo(contentTextView.snp.top)
            $0.height.equalTo(Const.title.height)
        }
        
        contentTextView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.right.equalToSuperview().offset(-Const.margin)
            $0.bottom.equalToSuperview()
        }
    }
    
}

extension DetailTableViewCell: Configurable {
    
    typealias Model = DetailModel
    
    func configure(_ model: DetailModel) {
        titleLabel.text = model.title
        contentTextView.text = model.content
        contentTextView.sizeToFit()
    }
    
}
