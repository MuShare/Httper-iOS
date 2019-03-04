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

public class BindableObserver<ContainerType, ValueType>: ObserverType {
    
    private var _container: ContainerType?
    
    private let _binding: (ContainerType, ValueType) -> Void
    
    public init(container: ContainerType, binding: @escaping (ContainerType, ValueType) -> Void) {
        self._container = container
        self._binding = binding
    }
    
    /**
     Binds next element
     */
    public func on(_ event: Event<ValueType>) {
        switch event {
        case .next(let element):
            guard let _container = self._container else {
                fatalError("No _container in BindableObserver at time of a .Next event")
            }
            self._binding(_container, element)
        case .error:
            self._container = nil
        case .completed:
            self._container = nil
        }
    }
    
    deinit {
        self._container = nil
    }
    
}

extension BaseRow: ReactiveCompatible { }

public extension Reactive where Base: BaseRow, Base: RowType {
    
    public var value: ControlProperty<Base.Cell.Value?> {
        let source = Observable<Base.Cell.Value?>.create { [weak base] observer in
            if let _base = base {
                observer.onNext(_base.value)
                _base.onChange({ row in
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
    
    public var isHighlighted: ControlProperty<Bool> {
        let source = Observable<Bool>.create { [weak base] observer in
            if let _base = base {
                observer.onNext(_base.isHighlighted)
                _base.onCellHighlightChanged({ (_, row) in
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
