//
//  UIViewController+Extension.swift
//  Httper
//
//  Created by Meng Li on 2018/06/18.
//  Copyright © 2018 MuShare Group. All rights reserved.
//


extension UIViewController {
    
    var topOffSet: CGFloat {
        if #available(iOS 11.0, *) {
            return 0
        } else {
            return 64.0
        }
    }

    var topPadding: CGFloat {
        return UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
    }
    
    var topPaddingFullScreen: CGFloat {
        let padding = UIApplication.shared.statusBarFrame.height
        return padding == 20 ? 0 : padding
    }
    
    var bottomPadding: CGFloat {
        var bottom: CGFloat = 0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                bottom += window.safeAreaInsets.bottom
            }
        }
        return bottom
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
