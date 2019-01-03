//
//  SaveToProjectViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/01/03.
//  Copyright © 2019 MuShare Group. All rights reserved.
//

import RxSwift
import RxCocoa

class SaveToProjectViewModel: BaseViewModel {
    
    private let projects = BehaviorRelay<[Project]>(value: DaoManager.shared.projectDao.findAll())
    
    let title = Observable.just("Save to Project")
    
    override init() {
        super.init()
        SyncManager.shared.pullUpdatedProjects { [weak self] revision in
            // Pull successfully.
            if revision > 0 {
                self?.projects.accept(DaoManager.shared.projectDao.findAll())
                // Push local projects to server in background.
                SyncManager.shared.pushLocalProjects(nil)
            }
        }
    }
    
    var projectSection: Observable<SingleSection<Project>> {
        return projects.map { SingleSection.create($0) }
    }

    func pickProject(at index: Int) {
        guard index < projects.value.count else {
            return
        }
        
    }
    
}
