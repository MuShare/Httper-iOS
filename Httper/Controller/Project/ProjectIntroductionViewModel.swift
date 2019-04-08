//
//  ProjectIntroductionViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/04/09.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

class ProjectIntroductionViewModel: BaseViewModel {
    
    private let project: Project
    
    init(project: Project) {
        self.project = project
        self.introduction = BehaviorRelay(value: project.introduction)
        super.init()
    }
    
    let introduction: BehaviorRelay<String?>
    
    var title: Observable<String> {
        return Observable.just(project.pname).unwrap()
    }
    
    var isValidate: Observable<Bool> {
        return introduction.map {
            guard let introduction = $0 else {
                return false
            }
            return !introduction.isEmpty
        }
    }
    
    func save() {
        guard let introduction = introduction.value, !introduction.isEmpty else {
            return
        }
        loading.onNext(true)
        project.introduction = introduction
        project.revision = 0
        DaoManager.shared.saveContext()
        SyncManager.shared.pushLocalProjects { [weak self] _ in
            guard let `self` = self else { return }
            self.loading.onNext(false)
            self.steps.accept(ProjectStep.introductionIsComplete)
        }
    }
    
}
