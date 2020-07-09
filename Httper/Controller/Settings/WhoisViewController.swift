//
//  WhoisViewController.swift
//  Httper
//
//  Created by Meng Li on 30/12/2016.
//  Copyright © 2016 MuShare Group. All rights reserved.
//

import RxSwift

private struct Const {
    
    struct icon {
        static let size = 30
        static let margin: CGFloat = 15
    }
    
    struct address {
        static let height = 40
        static let margin = 15
    }
    
    struct line {
        static let height = 1
        static let marginTop = 10
    }
    
    struct result {
        static let marginTop = 10
    }
    
}

class WhoisViewController: BaseViewController<WhoisViewModel> {

    private lazy var searchBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        barButtonItem.rx.tap.bind { [unowned self] in
            self.addressTextField.resignFirstResponder()
            self.viewModel.search()
        }.disposed(by: disposeBag)
        return barButtonItem
    }()
    
    private lazy var iconImageView = UIImageView(image: R.image.global())
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: R.string.localizable.whois_address_placeholder(),
            attributes: [.foregroundColor: UIColor.lightGray
            ]
        )
        textField.becomeFirstResponder()
        textField.rx.shouldReturn.bind { [unowned self] in
            textField.resignFirstResponder()
            self.viewModel.search()
        }.disposed(by: disposeBag)
        return textField
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private lazy var resultWebView: UIWebView = {
        let webView = UIWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }()
    
    private lazy var loadingActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = searchBarButtonItem
        view.backgroundColor = .background
    }
    override func subviews() -> [UIView] {
        [
            iconImageView,
            addressTextField,
            lineView,
            resultWebView,
            loadingActivityIndicatorView
        ]
    }
    
    override func bind() -> [Disposable] {
        [
            viewModel.title ~> rx.title,
            viewModel.isSearchBarButtonItemEnabled ~> searchBarButtonItem.rx.isEnabled,
            viewModel.isLoading ~> loadingActivityIndicatorView.rx.isAnimating,
            viewModel.domain <~> addressTextField.rx.text,
            viewModel.html ~> resultWebView.rx.html
        ]
    }
    
    override func createConstraints() {
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(Const.icon.size)
            $0.left.equalToSuperview().offset(Const.icon.margin)
            $0.top.equalTo(view.safeArea.top).offset(Const.icon.margin + topOffSet)
        }
        
        addressTextField.snp.makeConstraints {
            $0.height.equalTo(Const.address.height)
            $0.centerY.equalTo(iconImageView)
            $0.left.equalTo(iconImageView.snp.right).offset(Const.address.margin)
            $0.right.equalToSuperview().offset(-Const.address.margin)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(Const.line.height)
            $0.left.equalTo(iconImageView)
            $0.top.equalTo(addressTextField.snp.bottom).offset(Const.line.marginTop)
            $0.right.equalToSuperview()
        }
        
        resultWebView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(lineView.snp.bottom).offset(Const.result.marginTop)
            $0.bottom.equalToSuperview()
        }
        
        loadingActivityIndicatorView.snp.makeConstraints {
            $0.center.equalTo(resultWebView)
        }
        
    }
    
}
