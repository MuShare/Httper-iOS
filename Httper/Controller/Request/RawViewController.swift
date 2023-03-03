//
//  RowViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import RxCocoa
import RxSwift
import MGFormatter

fileprivate struct Const {
    static let margin = 5
}

class RawViewController: BaseViewController<RawViewModel> {
    
    private lazy var rawView = FormatterView()
 
    override func subviews() -> [UIView] {
        return [
            rawView
        ]
    }
    
    override func bind() -> [Disposable] {
        return [
            viewModel.text ~> rx.rawText
        ]
    }
    
    override func createConstraints() {
        rawView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.right.equalToSuperview().offset(-Const.margin)
            $0.top.bottom.equalToSuperview()
        }
    }
}

private extension RawViewController {
    func format(string: String) {
        rawView.format(string: string, style: .noneDark)
    }
}

extension Reactive where Base: RawViewController {
    var rawText: Binder<String> {
        Binder(base) { viewController, text in
            viewController.format(string: text)
        }
    }
}
