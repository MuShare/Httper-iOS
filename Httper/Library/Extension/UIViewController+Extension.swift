//
//  UIViewController+Extension.swift
//  Httper
//
//  Created by Meng Li on 2018/06/18.
//  Copyright © 2018 limeng. All rights reserved.
//

import UIKit

extension UIViewController {

    func showTip(_ tip: String) {
        showAlert(title: R.string.localizable.tip_name(),
                  content: tip)
    }

    func showAlert(title: String, content: String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: title,
                                                    message: content,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: R.string.localizable.ok_name(), style: .cancel))
            self?.present(alertController, animated: true)
        }
        
    }

    func replaceBarButtonItemWithActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicatorView.startAnimating()
        replaceBaeButtonItemWithView(view: activityIndicatorView)
    }

    func replaceBaeButtonItemWithView(view: UIView) {
        let barButton = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = barButton
    }

}
