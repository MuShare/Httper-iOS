//
//  ProjectViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/25.
//  Copyright © 2018 limeng. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
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

class ProjectViewModel {
    
    private let project: Project
    
    private let requests: BehaviorRelay<[Request]>
    
    init(project: Project) {
        self.project = project
        guard let array = project.requests?.array, let requests = array as? [Request] else {
            self.requests = BehaviorRelay(value: [])
            return
        }
        self.requests = BehaviorRelay(value: requests)
        syncProject()
    }

    var selectionSection: Observable<ProjectSectionModel> {
        return Observable.just(ProjectSectionModel.selectionSection(title: "Selction", items: [
            .selectionItem(Selection(icon: R.image.tab_project(), title: project.pname ?? "Project Name")),
            .selectionItem(Selection(icon: R.image.privilege(), title: project.privilege ?? "Privilege")),
            .selectionItem(Selection(icon: R.image.introduction(), title: "Introduction"))
        ]))
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
        return Observable.just(project.pname ?? "")
    }
    
    func syncProject(completion: (() -> ())? = nil) {
        SyncManager.shared.pullUpdatedRequests { [weak self] _ in
            if let requests = self?.project.requests?.array as? [Request] {
                self?.requests.accept(requests)
            }
            completion?()
        }
    }
    
}

extension ProjectViewModel: Stepper {
    
    func pick(at indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            break
        case (0, 1):
            break
        case (0, 2):
            break
        case (1, _):
            guard indexPath.row < requests.value.count else {
                return
            }
            step.accept(ProjectStep.request(requests.value[indexPath.row]))
        case (2, 0):
            break
        default:
            break
        }
    }
    
}
