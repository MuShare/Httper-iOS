use_frameworks!
platform :ios, '12.0'

target 'Httper' do
    pod 'Alamofire'
    pod 'ESPullToRefresh'
    pod 'Eureka'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FirebaseCrashlytics'
    pod 'Firebase/Performance'
    pod 'Kanna'
    pod 'Kingfisher'
    pod 'M80AttributedLabel'
    pod 'MGFormatter'
    pod 'MGKeyboardAccessory/Rx'
    pod 'MGSelector'
    pod 'NVActivityIndicatorView', '= 4.8.0'
    pod 'PagingKit'
    pod 'R.swift'
    pod 'ReachabilitySwift'
    pod 'Reusable'
    pod 'RxAlamofire'
    pod 'RxAlertViewable'
    pod 'RxBinding'
    pod 'RxCocoa'
    pod 'RxController'
    pod 'RxDataSourcesSingleSection'
    pod 'RxFlow'
    pod 'RxKeyboard'
    pod 'RxSwift'
    pod 'SnapKit'
    pod 'SwipeBack'
    pod 'SwiftyUserDefaults'
    pod 'SwiftyJSON'
    pod 'UIGradient'
    pod 'UIImageView+Extension'
    pod 'UITextView+Placeholder'

    target 'HttperTests' do
        inherit! :search_paths
    end
end

post_install do |installer|
    system("bash #{Pathname(installer.sandbox.root)}/RxController/rxtree/build_for_xcode.sh")
end
