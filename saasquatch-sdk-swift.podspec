Pod::Spec.new do |s|
  s.name             = 'saasquatch-sdk-swift'
  s.version          = '1.1.1'
  s.summary          = 'The Swift version of the Referral SaaSquatch IOS SDK'
  s.description      = <<-DESC
This SDK was built to interact with Referral Saasquatch. For more information, please visit https://docs.referralsaasquatch.com/mobile/ios/
                       DESC

  s.homepage         = 'http://www.referralsaasquatch.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Referral Saasquatch' => 'hello@saasquat.ch', 'Trevor Lee' => 'trevor.lee@referralsaasquatch.com', }
  s.source           = { :git => 'https://github.com/saasquatch/mobile-sdk-swift-cocoapod.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'saasquatch/classes/*.{swift,h}'
  s.module_name = 'saasquatch'
  s.requires_arc = true
end
