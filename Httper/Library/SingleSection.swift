//
//  SingleSection.swift
//  athene
//
//  Created by Meng Li on 2018/09/06.
//  Copyright © 2018 XFLAG. All rights reserved.
//

import RxDataSources

// SectionedReloadDataSource
struct SingleSectionModel<T>: SectionModelType {
    
    typealias Item = T
    
    var items: [T]
    
    init(items: [T]) {
        self.items = items
    }
    
    init(original: SingleSectionModel<T>, items: [T]) {
        self = original
    }
    
    static func create(_ items: [T]) -> SingleSection<T> {
        return [SingleSectionModel(items: items)]
    }
    
}

typealias SingleSection<T> = [SingleSectionModel<T>]

extension SingleSection where Element: SectionModelType {
    static func create(_ items: [Element.Item]) -> SingleSection<Element.Item> {
        return [SingleSectionModel(items: items)]
    }
}

typealias TableViewSingleSectionDataSource<T> = RxTableViewSectionedReloadDataSource<SingleSectionModel<T>>
typealias CollectionViewSingleSectionDataSource<T> = RxCollectionViewSectionedReloadDataSource<SingleSectionModel<T>>

// AnimatableSectionedReloadDataSource
protocol AnimatableModel: IdentifiableType, Equatable {}

struct AnimatableSingleSectionModel<T: AnimatableModel>: AnimatableSectionModelType {
    
    typealias Item = T
    typealias Identity = String
    
    var items: [T]
    var identity: String
    
    init(items: [T]) {
        self.items = items
        self.identity = ""
    }
    
    init(original: AnimatableSingleSectionModel<T>, items: [T]) {
        self = original
        self.items = items
    }
    
    static func create(_ items: [T]) -> AnimatableSingleSection<T> {
        return [AnimatableSingleSectionModel(items: items)]
    }
    
}

typealias AnimatableSingleSection<T: AnimatableModel> = [AnimatableSingleSectionModel<T>]

extension AnimatableSingleSection where Element: AnimatableSectionModelType, Element.Item: AnimatableModel {
    static func create(_ items: [Element.Item]) -> AnimatableSingleSection<Element.Item> {
        return [AnimatableSingleSectionModel(items: items)]
    }
}

typealias TableViewAnimatedSingleSectionDataSource<T: AnimatableModel> = RxTableViewSectionedAnimatedDataSource<AnimatableSingleSectionModel<T>>
typealias CollectionViewAnimatedSingleSectionDataSource<T: AnimatableModel> = RxCollectionViewSectionedAnimatedDataSource<AnimatableSingleSectionModel<T>>

