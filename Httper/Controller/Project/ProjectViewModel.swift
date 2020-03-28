//
//  ProjectViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/25.
//  Copyright © 2018 limeng. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

enum ProjectSectionItem {
    case selectionItem(Selection)
    case requestItem(Request)
    case deleteItem
}

enum ProjectSectionModel {
    case selectionSection(title: String, items: [ProjectSectionItem])
    case requestsSection(title: String, items: [ProjectSectionItem])
    case deleteSection(title: String, items: [ProjectSectionItem])
}

extension ProjectSectionModel: SectionModelType {

    typealias Item = ProjectSectionItem
    
    var items: [ProjectSectionItem] {
        switch self {
        case let .selectionSection(title: _, items: items):
            return items.map { $0 }
        case let .requestsSection(title: _, items: items):
            return items.map { $0 }
        case let .deleteSection(title: _, items: items):
            return items.map { $0 }
        }
    }
    
    init(original: ProjectSectionModel, items: [ProjectSectionItem]) {
        self = original
    }
    
    var title: String {
        switch self {
        case .selectionSection(title: let title, items: _):
            return title
        case .requestsSection(title: let title, items: _):
            return title
        case .deleteSection(title: let title, items: _):
            return title
        }
    }
    
}

class ProjectViewModel: BaseViewModel {
    
    private let project: BehaviorRelay<Project>
    private let requests: BehaviorRelay<[Request]>
    
    init(project: Project) {
        self.project = BehaviorRelay(value: project)
        if let array = project.requests?.array, let requests = array as? [Request]  {
            self.requests = BehaviorRelay(value: requests)
        } else {
            self.requests = BehaviorRelay(value: [])
        }
        super.init()
    }

    var selectionSection: Observable<ProjectSectionModel> {
        return project.map {
            ProjectSectionModel.selectionSection(title: "Selction", items: [
                .selectionItem(Selection(icon: R.image.tab_project(), title: $0.pname ?? "Project Name")),
                .selectionItem(Selection(icon: R.image.privilege(), title: $0.privilege ?? "Privilege")),
                .selectionItem(Selection(icon: R.image.introduction(), title: "Introduction"))
            ])
        }
    }
    
    let deleteSection = Observable.just(ProjectSectionModel.deleteSection(title: "Delete", items: [.deleteItem]))
    
    var requestSection: Observable<ProjectSectionModel> {
        return requests.map {
            ProjectSectionModel.requestsSection(title: "Requests", items: $0.map {
                ProjectSectionItem.requestItem($0)
            })
        }
    }
    
    var sections: Observable<[ProjectSectionModel]> {
        return Observable.combineLatest(selectionSection, requestSection, deleteSection).map {
            [$0, $1, $2]
        }
    }
    
    var title: Observable<String> {
        return project.map { $0.pname }.unwrap()
    }
    
    func syncProject(completion: (() -> ())? = nil) {
        if let pid = project.value.pid, let project = DaoManager.shared.projectDao.getByPid(pid) {
            self.project.accept(project)
        }
        
        SyncManager.shared.pullUpdatedRequests { [weak self] _ in
            guard let `self` = self else { return }
            if let requests = self.project.value.requests?.array as? [Request] {
                self.requests.accept(requests)
            }
            completion?()
        }
    }
    
    func pick(at indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            steps.accept(ProjectStep.name(project.value))
        case (0, 1):
            break
        case (0, 2):
            steps.accept(ProjectStep.introduction(project.value))
        case (1, _):
            guard indexPath.row < requests.value.count else {
                return
            }
            steps.accept(ProjectStep.request(requests.value[indexPath.row]))
        case (2, 0):
            alert.onNextCustomConfirm(
                title: R.string.localizable.project_delete(),
                message: R.string.localizable.project_delete_message(),
                onConfirm: { [unowned self] in
                    self.loading.onNext(true)
                    SyncManager.shared.deleteProject(self.project.value) { [weak self] _ in
                        guard let `self` = self else { return }
                        self.loading.onNext(false)
                        self.steps.accept(ProjectStep.projectIsComplete)
                    }
                }
            )
        default:
            break
        }
    }
    
    func deleteRequest(at index: Int) {
        var requests = self.requests.value
        guard 0 ..< requests.count ~= index else {
            return
        }
        SyncManager.shared.deleteRequest(requests[index])
        requests.remove(at: index)
        self.requests.accept(requests)
    }
    
}
