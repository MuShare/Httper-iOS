//
//  DetailViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/10/03.
//  Copyright © 2018 MuShare. All rights reserved.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    private let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
