use_frameworks!
platform :ios, '9.0'

target 'Httper' do
    pod 'Alamofire', '~> 4'
    pod 'M80AttributedLabel', '~> 1.6'
    pod 'Kanna', '~> 4'
    pod 'UILabel+Copyable', '~> 1.0'
    pod 'UITextView+Placeholder', '~> 1.2'
    pod 'DGElasticPullToRefresh', '~> 1.1'
    pod 'MGKeyboardAccessory', '~> 0.4'
    pod 'FacebookCore', '~> 0.2'
    pod 'FacebookLogin', '~> 0.2'
    pod 'ReachabilitySwift', '~> 3'
    pod 'SwiftyUserDefaults', '~> 3'
    pod 'SwiftyJSON', '~> 3.1'
    pod 'NVActivityIndicatorView', '~> 4'
    pod 'Kingfisher', '~> 4'
    pod 'UIImageView+Extension', '~> 0.2'
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