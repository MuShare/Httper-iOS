//
//  RowViewController.swift
//  Httper
//
//  Created by Meng Li on 09/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import UIKit
import M80AttributedLabel

class RawViewController: UIViewController {
    
    private lazy var rowLabel: M80AttributedLabel = {
        let label = M80AttributedLabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "Menlo", size: 12)
        label.textColor = .normal
        return label
    }()
    
    private lazy var rowScrollView: UIScrollView = {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let rowSize = rowLabel.sizeThatFits(CGSize(width: width - 10, height: CGFloat.greatestFiniteMagnitude))
        rowLabel.frame = CGRect(x: 5, y: 5, width: rowSize.width, height: rowSize.height)
        
        let view = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: height - 50))
        view.backgroundColor = .clear
        view.contentSize = CGSize(width: width, height: rowSize.height + 70)
        view.addSubview(rowLabel)
        return view
    }()
    
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

        view.addSubview(rowScrollView)
        viewModel.text.bind(to: rowLabel.rx.text).disposed(by: disposeBag)
        viewModel.text.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
}
