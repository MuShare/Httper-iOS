//
//  Eruka+Rx.swift
//  Tsukuba-iOS
//
//  Created by Meng Li on 2019/01/18.
//  Copyright © 2019 MuShare. All rights reserved.
//

import Eureka
import RxSwift
import RxCocoa

class BindableObserver<ContainerType, ValueType>: ObserverType {
    
    private var container: ContainerType?
    
    private let binding: (ContainerType, ValueType) -> Void
    
    deinit {
        container = nil
    }
    
    init(container: ContainerType, binding: @escaping (ContainerType, ValueType) -> Void) {
        self.container = container
        self.binding = binding
    }
    
    func on(_ event: Event<ValueType>) {
        switch event {
        case .next(let element):
            guard let container = container else {
                fatalError("No _container in BindableObserver at time of a .Next event")
            }
            binding(container, element)
        case .error:
            container = nil
        case .completed:
            container = nil
        }
    }
    
}

extension BaseRow: ReactiveCompatible { }

extension Reactive where Base: BaseRow, Base: RowType {
    
    var value: ControlProperty<Base.Cell.Value?> {
        let source = Observable<Base.Cell.Value?>.create { [weak base] observer in
            if let base = base {
                observer.onNext(base.value)
                base.onChange({ row in
                    observer.onNext(row.value)
                })
            }
            return Disposables.create {
                observer.onCompleted()
            }
        }
        let bindingObserver = BindableObserver(container: self.base) { (row, value) in
            row.value = value
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
    
    var isHighlighted: ControlProperty<Bool> {
        let source = Observable<Bool>.create { [weak base] observer in
            if let base = base {
                observer.onNext(base.isHighlighted)
                base.onCellHighlightChanged({ (_, row) in
                    observer.onNext(row.isHighlighted)
                })
            }
            return Disposables.create {
                observer.onCompleted()
            }
        }
        let bindingObserver = BindableObserver(container: self.base) { (row, isHighlighted) in
            row.isHighlighted = isHighlighted
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
    
}

