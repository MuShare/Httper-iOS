//
//  DetailViewModel.swift
//  Httper
//
//  Created by Meng Li on 2018/10/05.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxDataSourcesSingleSection

struct DetailModel {
    var title: String
    var content: String
}

class DetailViewModel: BaseViewModel {
    
    let response = BehaviorSubject<HTTPURLResponse?>(value: nil)
    
    var detailSection: Observable<SingleSection<DetailModel>> {
        return response.map {
            guard let response = $0 else {
                return SingleSection.create([])
            }
            var models: [DetailModel] = []
            models.append(DetailModel(title: "Request URL", content: response.url?.description ?? ""))
            models.append(DetailModel(title: "Status Code", content: response.statusCode.description))
            response.allHeaderFields.forEach { (key, value) in
                models.append(DetailModel(title: key.description, content: value as? String ?? ""))
            }
            return SingleSection.create(models)
        }
    }
    
}
