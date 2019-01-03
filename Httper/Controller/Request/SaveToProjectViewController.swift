//
//  SaveToProjectViewController.swift
//  Httper
//
//  Created by Meng Li on 2019/01/03.
//  Copyright © 2019 MuShare Group. All rights reserved.
//

import UIKit

class SaveToProjectViewController: HttperViewController {
    
    private let viewModel: SaveToProjectViewModel
    
    init(viewModel: SaveToProjectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.title.bind(to: rx.title).disposed(by: disposeBag)
    }
    
}
