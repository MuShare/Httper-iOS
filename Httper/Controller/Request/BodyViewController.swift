//
//  RequestBodyViewController.swift
//  Httper
//
//  Created by Meng Li on 12/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import RxSwift
import MGKeyboardAccessory

fileprivate struct Const {
    struct rawBody {
        static let margin = 10
    }
}

class BodyViewController: BaseViewController<BodyViewModel> {
    
    private lazy var rawBodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.setupKeyboardAccessory(UserManager.shared.characters ?? [], barStyle: .black)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rawBodyTextView)
        createConstraints()
        
        viewModel.body <~> rawBodyTextView.rx.text.orEmpty ~ disposeBag
    }
    
    private func createConstraints() {
        rawBodyTextView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(Const.rawBody.margin)
            $0.right.equalToSuperview().offset(-Const.rawBody.margin)
        }
    }
    
}
