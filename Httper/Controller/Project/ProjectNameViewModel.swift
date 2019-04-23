//
//  ProjectNameViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/04/09.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

class ProjectNameViewModel: BaseViewModel {
 
    private let project: Project
    
    let name = BehaviorRelay<String?>(value: nil)
    
    var title: Observable<String> {
        return Observable.just(project.pname).unwrap()
    }
    
    var isValidate: Observable<Bool> {
        return name.map {
            guard let name = $0 else {
                return false
            }
            return !name.isEmpty
        }
    }
    
    init(project: Project) {
        self.project = project
        super.init()
    }
    
    func save() {
        guard let name = name.value, !name.isEmpty else {
            return
        }
        loading.onNext(true)
        project.pname = name
        project.revision = 0
        DaoManager.shared.saveContext()
        SyncManager.shared.pushLocalProjects { [weak self] _ in
            guard let `self` = self else { return }
            self.loading.onNext(false)
            self.steps.accept(ProjectStep.nameIsComplete)
        }
    }
    
}
