# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'kcuc' do
  use_frameworks!

  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'ObjectMapper'
  pod 'CocoaLumberjack/Swift'
  pod 'SVProgressHUD'
end

post_install do | installer |
  require 'fileutils'

  FileUtils.cp_r('Pods/Target Support Files/Pods-kcuc/Pods-kcuc-acknowledgements.plist', 'kcuc/SupportingFiles/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
