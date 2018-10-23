use_frameworks!
platform :ios, '9.0'

target 'Httper' do
    pod 'Alamofire', '~> 4'
    pod 'DGElasticPullToRefresh', '~> 1.1'
    pod 'FacebookCore', '~> 0.2'
    pod 'FacebookLogin', '~> 0.2'
    pod 'Kanna', '~> 4'
    pod 'Kingfisher', '~> 4'
    pod 'M80AttributedLabel', '~> 1'
    pod 'MGFormatter', '~> 0.3'
    pod 'MGKeyboardAccessory', '~> 0.4'
    pod 'MGSelector', '~> 0.1'
    pod 'NVActivityIndicatorView', '~> 4'
    pod 'PagingKit', '~> 1'
    pod 'R.swift', '= 5.0.0.alpha.2'
    pod 'ReachabilitySwift', '~> 3'
    pod 'Reusable', '~> 4'
    pod 'RxAlamofire', '~> 4.3'
    pod 'RxSwift', '~> 4'
    pod 'RxCocoa', '~> 4'
    pod 'RxDataSources', '~> 3'
    pod 'RxFlow', '~> 1.4'
    pod 'RxKingfisher', '~> 0.2'
    pod 'SnapKit', '~> 4'
    pod 'SwipeBack', '~> 1'
    pod 'SwiftyUserDefaults', '~> 3'
    pod 'SwiftyJSON', '~> 4'
    pod 'UIGradient', '~> 1.2'
    pod 'UIImageView+Extension', '~> 0.2'
    pod 'UITextView+Placeholder', '~> 1.2'
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
