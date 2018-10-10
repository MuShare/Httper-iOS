//
//  RowViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import RxSwift
import MGFormatter

class RawViewController: UIViewController {
    
    private lazy var rawView = FormatterView()
    
    private let viewModel: RawViewModel

    init(viewModel: RawViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(rawView)
        createConstrants()
        viewModel.text.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] in
            self.rawView.format(string: $0, style: .noneDark)
        }).disposed(by: disposeBag)
    }
 
    private func createConstrants() {
        rawView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
