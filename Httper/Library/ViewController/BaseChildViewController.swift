//
//  BaseChildViewController.swift
//  Rinrin
//
//  Created by Meng Li on 2019/04/17.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxController
import RxAlertViewable

class BaseChildViewController<ViewModel: BaseChildViewModel>: RxChildViewController<ViewModel> {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.alert ~> rx.alert ~ disposeBag
    }
    
}

extension BaseChildViewController: RxAlertViewable {
    
}
