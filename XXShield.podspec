#
# Be sure to run `pod lib lint XXShield.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XXShield'
  s.version          = '1.0.0'
  s.summary          = 'Avoid Crash'



  s.description      = <<-DESC
  1. unrecoginzed Selector Crash
  2. KVO Crash
  3. Container Crash
  4. NSNotification Crash
  5. NSNull Crash
  6. NSTimer Crash
  7. 野指针 Crash  "

  DESC

  s.homepage         = 'https://github.com/ValiantCat/XXShield'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ValiantCat' => '519224747@qq.com' }
  s.source           = { :git => 'https://github.com/ValiantCat/XXShield.git', :tag => s.version.to_s }
  s.platform         = :ios, '7.0'

  s.ios.deployment_target = '7.0'

  s.public_header_files   = "XXShield/Classes/*.h"
  s.source_files          = "XXShield/Classes/*/*.{h,m,mm}", "XXShield/Classes/*.{h,m,mm}"

  non_arc_files = "XXShield/Classes/DanglingPointerShield/NSObject+DanglingPointer.m"

  s.exclude_files = non_arc_files
  s.requires_arc = true
  s.subspec 'no-arc' do |sna|
    sna.requires_arc = false
    sna.source_files = non_arc_files
  end




  s.dependency 'libextobjc'
  s.dependency 'Crashlytics'
end
