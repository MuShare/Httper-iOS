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
        
        viewModel.body.twoWayBind(to: rawBodyTextView.rx.text.orEmpty).disposed(by: disposeBag)
    }
    
    private func createConstraints() {
        rawBodyTextView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
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
