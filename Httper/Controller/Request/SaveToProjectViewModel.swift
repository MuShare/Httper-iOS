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
    
    private let requestData: RequestData
    private let projects = BehaviorRelay<[Project]>(value: DaoManager.shared.projectDao.findAll())

    init(requestData: RequestData) {
        self.requestData = requestData
        super.init()
    }
    
    func syncProjects(completion: (() -> Void)? = nil) {
        SyncManager.shared.pullUpdatedProjects { [weak self] revision in
            // Pull successfully.
            if revision > 0 {
                self?.projects.accept(DaoManager.shared.projectDao.findAll())
                // Push local projects to server in background.
                SyncManager.shared.pushLocalProjects(nil)
            }
            completion?()
        }
    }
    
    let title = Observable.just("Save to Project")
    
    var projectSection: Observable<SingleSection<Project>> {
        return projects.map { SingleSection.create($0) }
    }

    func pickProject(at index: Int) {
        guard index < projects.value.count else {
            return
        }
        
    }
    
    func addProject() {
        steps.accept(RequestStep.addProject(RequestStep.addProjectIsComplete))
    }
    
}
