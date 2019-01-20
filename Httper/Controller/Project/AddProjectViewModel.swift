//
//  AddProjectViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/01/10.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

class AddProjectViewModel: BaseViewModel {
    
    let projectName = BehaviorRelay<String?>(value: nil)
    let introduction = BehaviorRelay<String?>(value: nil)
    
    let title = Observable.just("Add Project")
    
    func saveProject() {
        
    }
    
}
