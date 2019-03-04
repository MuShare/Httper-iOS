use_frameworks!
platform :ios, '9.0'

target 'Httper' do
    pod 'Alamofire'
    pod 'DGElasticPullToRefresh'
    pod 'Eureka'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'Kanna'
    pod 'Kingfisher'
    pod 'M80AttributedLabel'
    pod 'MGFormatter'
    pod 'MGKeyboardAccessory'
    pod 'MGSelector'
    pod 'NVActivityIndicatorView'
    pod 'PagingKit'
    pod 'R.swift'
    pod 'ReachabilitySwift'
    pod 'Reusable'
    pod 'RxAlamofire'
    pod 'RxAlertViewable'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'RxFlow'
    pod 'RxKingfisher'
    pod 'SnapKit'
    pod 'SwipeBack'
    pod 'SwiftyUserDefaults'
    pod 'SwiftyJSON'
    pod 'UIGradient'
    pod 'UIImageView+Extension'
    pod 'UITextView+Placeholder'
end

post_install do |installer|
    targets_3 = ['DGElasticPullToRefresh']

    installer.pods_project.targets.each do |target|
        if targets_3.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.1'
            end
        end
    end
end
