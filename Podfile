platform :ios, '11.4'

def common_pods
    use_frameworks!
    pod 'RxAtomic', '~> 4.4'
    pod 'RxSwift', '~> 4.4'
    pod 'RxCocoa', '~> 4.4'
    pod 'RxGesture', '~> 2.1'
    pod 'Alamofire', '~> 4.8'
    pod 'Firebase/Core', '~> 5.15'
    pod 'Firebase/RemoteConfig', '~> 5.15'
    pod 'Fabric', '~> 1.9.0'
    pod 'Crashlytics', '~> 3.12.0'
end

target 'HabitTracker' do
    common_pods

    target 'HabitTrackerTests' do
        inherit! :search_paths
        pod 'Quick', '~> 1.3'
        pod 'Nimble', '~> 7.3'
    end
end

#target 'HabitTrackerTests' do
#    pod 'Quick', '~> 1.3'
#    pod 'Nimble', '~> 7.3'
#    common_pods
#end
