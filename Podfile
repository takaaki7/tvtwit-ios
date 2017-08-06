# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

# fix for non numeric CocoaPods versions
# https://github.com/CocoaPods/CocoaPods/issues/4421#issuecomment-151804311
post_install do |installer|
    plist_buddy = "/usr/libexec/PlistBuddy"
    installer.pods_project.targets.each do |target|
        plist = "Pods/Target Support Files/#{target}/Info.plist"
        original_version = `#{plist_buddy} -c "Print CFBundleShortVersionString" "#{plist}"`.strip
        changed_version = original_version[/(\d+\.){1,2}(\d+)?/]
        unless original_version == changed_version
            puts "Fix version of Pod #{target}: #{original_version} => #{changed_version}"
            `#{plist_buddy} -c "Set CFBundleShortVersionString #{changed_version}" "Pods/Target Support Files/#{target}/Info.plist"`
        end
    end
end

target 'tvtwit' do
    pod 'Alamofire', '3.1.2'
    pod 'Socket.IO-Client-Swift', '~> 5.5.0'
    pod 'ReactiveCocoa', '4.1.0'
    pod 'SDWebImage', '~>3.6'
    pod "Himotoki", "2.1.1"
end
source 'https://github.com/CocoaPods/Specs.git'
def testing_pods
    pod 'Quick', '~> 0.9.3'
    pod 'Nimble', '~> 4.1.0'
end

target 'tvtwitModelTests' do
    testing_pods
end

