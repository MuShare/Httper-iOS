//
//  PrettyViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import MGFormatter
import RxSwift

fileprivate struct Const {
    static let margin = 5
}

class PrettyViewController: BaseViewController<PrettyViewModel> {
    
    private lazy var formatterView = FormatterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(formatterView)
        createConstraints()
        
        Observable.combineLatest(viewModel.text, viewModel.style).subscribe(onNext: { [unowned self] (text, style) in
            self.formatterView.format(string: text, style: style)
        }).disposed(by: disposeBag)
    }
    
    override func createConstraints() {
        formatterView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Const.margin)
            $0.right.equalToSuperview().offset(Const.margin)
            $0.top.bottom.equalToSuperview()
        }
    }
    
}
