//
//  UITableView+Rx.swift
//  Httper
//
//  Created by Meng Li on 2019/4/22.
//  Copyright © 2019 MuShare. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    
    var scrollToBottom: Binder<Void> {
        return Binder(self.base) { (tableView, _) in
            tableView.scrollToBottom(animated: false)
        }
    }
    
}
