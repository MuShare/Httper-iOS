//
//  UITableView+Extension.swift
//  Tsukuba-iOS
//
//  Created by mon.ri on 2018/07/02.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        if numberOfSections > 0 {
            let row = numberOfRows(inSection: numberOfSections - 1)
            if row > 0 {
                let index = IndexPath(row: row - 1, section: numberOfSections - 1)
                scrollToRow(at: index, at: .bottom, animated: animated)
            }
        }
    }
    
    func hideFooterView() {
        tableFooterView = UIView(frame: CGRect.zero)
        tableFooterView?.backgroundColor = UIColor.clear
    }
}
