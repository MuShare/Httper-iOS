//
//  RequestBodyViewController.swift
//  Httper
//
//  Created by Meng Li on 12/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import RxSwift
import MGKeyboardAccessory

private struct Const {
    struct rawBody {
        static let margin = 10
    }
}

class BodyViewController: BaseViewController<BodyViewModel> {
    
    private lazy var rawBodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.backgroundColor = UIColor(hexa: 0xffffff11)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        return textView
    }()
    
    override func subviews() -> [UIView] {
        [rawBodyTextView]
    }
    
    override func bind() -> [Disposable] {
        [
            viewModel.body <~> rawBodyTextView.rx.text,
            viewModel.characters ~> rawBodyTextView.rx.keyboardAccessoryStrings(style: .black)
        ]
    }
    
    override func createConstraints() {
        rawBodyTextView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(Const.rawBody.margin)
            $0.right.equalToSuperview().offset(-Const.rawBody.margin)
            $0.bottom.equalToSuperview().offset(-Const.rawBody.margin)
        }
    }
    
}
