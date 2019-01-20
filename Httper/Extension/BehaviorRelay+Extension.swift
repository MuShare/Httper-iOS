//
//  BehaviorRelay+Extension.swift
//  Httper
//
//  Created by Meng Li on 2018/10/02.
//  Copyright © 2018 MuShare. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension BehaviorRelay where Element == String {

    public func twoWaybind<Base>(to textInput: TextInput<Base>) -> Disposable {
        let bindToUIDisposable = self.bind(to: textInput.text)
        
        let bindToRelay = textInput.text.subscribe(onNext: { [weak base = textInput.base] n in
            guard let base = base else {
                return
            }
            
            let nonMarkedTextValue = self.nonMarkedText(base)
            
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != relay.value {
             relay.accept(nonMarkedTextValue ?? "")
             }
             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != self.value {
                self.accept(nonMarkedTextValue)
            }
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
        
        return Disposables.create(bindToUIDisposable, bindToRelay)
    }
    
    private func nonMarkedText(_ textInput: UITextInput) -> String? {
        let start = textInput.beginningOfDocument
        let end = textInput.endOfDocument
        
        guard let rangeAll = textInput.textRange(from: start, to: end),
            let text = textInput.text(in: rangeAll) else {
                return nil
        }
        
        guard let markedTextRange = textInput.markedTextRange else {
            return text
        }
        
        guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
            let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
                return text
        }
        
        return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
    }
    
}

extension BehaviorRelay {
    
    func twoWayBind(to property: ControlProperty<E>) -> Disposable {
        if E.self == String.self {
            #if DEBUG
            fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to relay.\n" +
                "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
                "REMEDY: Just use `textField <-> relay` instead of `textField.rx.text <-> relay`.\n" +
                "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
            )
            #endif
        }
        
        let bindToUIDisposable = self.bind(to: property)
        let bindToRelay = property.subscribe(onNext: { n in
            self.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
        return Disposables.create(bindToUIDisposable, bindToRelay)
    }
    
}
