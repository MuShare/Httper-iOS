//
//  WhoisViewModel.swift
//  Httper
//
//  Created by Meng Li on 2019/08/20.
//  Copyright © 2019 MuShare. All rights reserved.
//

import Alamofire
import Kanna
import Reachability
import RxCocoa
import RxSwift

class WhoisViewModel: BaseViewModel {
    
    private let reachability = try? Reachability()
    
    private let css: String = {
        var css = "<style>"
        do {
            if let cssURL = R.file.whoisCss() {
                css += try String(contentsOf: cssURL, encoding: .utf8)
            }
        } catch let error {
            print("Failed reading, Error: " + error.localizedDescription)
        }
        css += "</style>"
        return css
    }()
    
    private let isSearchRelay = BehaviorRelay<Bool>(value: false)
    private let htmlSubject = PublishSubject<String>()
    
    let domain = BehaviorRelay<String?>(value: nil)
    
    var title: Observable<String> {
        return .just("Whois")
    }
    
    var isSearchBarButtonItemEnabled: Observable<Bool> {
        return Observable.combineLatest(isSearchRelay, domain).map { isSearch, domain in
            guard !isSearch, let domain = domain else {
                return false
            }
            return !domain.isEmpty
        }
    }
    
    var isLoading: Observable<Bool> {
        return isSearchRelay.asObservable()
    }
    
    var html: Observable<String> {
        return htmlSubject.asObservable()
    }
    func search() {
        guard reachability?.connection != .none else {
            alert.onNextTip(R.string.localizable.not_internet_connection())
            return
        }
        guard let domain = domain.value, !domain.isEmpty else {
            return
        }
        isSearchRelay.accept(true)
        Alamofire.request("https://www.whois.com/whois/" + domain).responseString { [weak self] in
            guard let `self` = self, let value = $0.result.value else {
                return
            }
            guard let doc = try? HTML(html: value, encoding: .utf8) else {
                return
            }
            self.isSearchRelay.accept(false)
            self.htmlSubject.onNext(doc.css(".df-block").compactMap {
                $0.toHTML
            }.reduce("<meta name='format-detection' content='telephone=no'/>" + self.css) {
                $0 + $1
            })
        }
    }
    
}
