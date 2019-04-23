//
//  MainViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/9/12.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import RxFlow

class MainViewModel: BaseViewModel {
    
    func clearRequest() {
        steps.accept(MainStep.clearRequest)
    }
    
    func addProject() {
        steps.accept(MainStep.addProject(MainStep.addProjectIsComplete))
    }
    
}
