Pod::Spec.new do |s|
  s.name             = "saasquatch-sdk-swift"
  s.version          = '1.1'
  s.summary          = 'The Swift version of the Referral SaaSquatch IOS SDK'

  s.description      = <<-DESC
This SDK was built from Referral SaaSquatch's open endpoints. The open endpoints can be found at https://docs.referralsaasquatch.com/api/openendpoints/
                       DESC

  s.homepage         = 'http://www.referralsaasquatch.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Referral Saasquatch' => 'trevor.lee@referralsaasquatch.com' }
  s.source           = { :git => 'https://github.com/saasquatch/mobile-sdk-swift-cocoapod.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'saasquatch/saasquatch/Saasquatch.swift'
  s.preserve_paths = "saasquatch/saasquatch/Saasquatch.swift'



end
