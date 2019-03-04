//
//  Operators.swift
//  Rinrin
//
//  Created by Meng Li on 2019/02/01.
//  Copyright © 2019 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa

infix operator ~> : DefaultPrecedence

extension ObservableType {

    static func ~> <O>(observable: Self, observer: O) -> Disposable where O: ObserverType, O.E == Self.E {
        return observable.bind(to: observer)
    }

    static func ~> <O>(observable: Self, observer: O) -> Disposable where O : ObserverType, O.E == Self.E?  {
        return observable.bind(to: observer)
    }

    static func ~> (observable: Self, relay: PublishRelay<Self.E>) -> Disposable {
        return observable.bind(to: relay)
    }

    static func ~> (observable: Self, relay: PublishRelay<Self.E?>) -> Disposable {
        return observable.bind(to: relay)
    }

    static func ~> (observable: Self, relay: BehaviorRelay<Self.E>) -> Disposable {
        return observable.bind(to: relay)
    }

    static func ~> (observable: Self, relay: BehaviorRelay<Self.E?>) -> Disposable {
        return observable.bind(to: relay)
    }
    
    static func ~> <R>(observable: Self, binder: (Self) -> R) -> R {
        return observable.bind(to: binder)
    }

}

extension ObservableType {
    
    static func ~> <O>(observable: Self, observers: [O]) -> [Disposable] where O: ObserverType, O.E == Self.E {
        return observers.map { observable.bind(to: $0) }
    }
    
    static func ~> <O>(observable: Self, observers: [O]) -> [Disposable] where O : ObserverType, O.E == Self.E?  {
        return observers.map { observable.bind(to: $0) }
    }
    
    static func ~> (observable: Self, relays: [PublishRelay<Self.E>]) -> [Disposable] {
        return relays.map { observable.bind(to: $0) }
    }
    
    static func ~> (observable: Self, relays: [PublishRelay<Self.E?>]) -> [Disposable] {
        return relays.map { observable.bind(to: $0) }
    }
    
    static func ~> (observable: Self, relays: [BehaviorRelay<Self.E>]) -> [Disposable] {
        return relays.map { observable.bind(to: $0) }
    }
    
    static func ~> (observable: Self, relays: [BehaviorRelay<Self.E?>]) -> [Disposable] {
        return relays.map { observable.bind(to: $0) }
    }
    
    static func ~> <R>(observable: Self, binders: [(Self) -> R]) -> [R] {
        return binders.map { observable.bind(to: $0) }
    }
    
}

infix operator <~> : DefaultPrecedence

func <~> <T>(relay: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    return relay.twoWayBind(to: property)
}

precedencegroup DisposePrecedence {
    associativity: left
    
    lowerThan: DefaultPrecedence
}


infix operator ~ : DisposePrecedence

extension DisposeBag {
    
    static func ~ (disposable: Disposable, disposeBag: DisposeBag) {
        disposable.disposed(by: disposeBag)
    }
    
}

extension Array where Element == Disposable {
    
    static func ~ (disposables: Array, disposeBag: DisposeBag) {
        disposables.forEach { $0.disposed(by: disposeBag) }
    }
    
}
