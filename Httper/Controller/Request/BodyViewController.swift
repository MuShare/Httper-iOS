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

class BodyViewController: UIViewController {
    
    private lazy var rawBodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.setupKeyboardAccessory(UserManager.shared.characters ?? [], barStyle: .black)
        return textView
    }()
    
    private let viewModel: BodyViewModel
    
    init(viewModel: BodyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rawBodyTextView)
        rawBodyTextView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
        
        viewModel.body.twoWayBind(to: rawBodyTextView.rx.text.orEmpty).disposed(by: disposeBag)
    }
    
    // MARK: - Action
    @IBAction func cleatRequestBody(_ sender: Any) {
        let alertController = UIAlertController(title: R.string.localizable.tip_name(),
                                                message: R.string.localizable.clear_request_body(),
                                                preferredStyle: .alert);
        alertController.addAction(UIAlertAction(title: R.string.localizable.cancel_name(),
                                                style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: R.string.localizable.yes_name(),
                                                style: .destructive) { action in
                                                    self.rawBodyTextView.text = ""
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
}
