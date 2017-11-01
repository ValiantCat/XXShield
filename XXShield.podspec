Pod::Spec.new do |s|
  s.name             = 'XXShield'
  s.version          = '1.0.1'
  s.summary          = 'Avoid Crash'
  s.description      = <<-DESC
  1. unrecoginzed Selector Crash
  2. KVO Crash
  3. Container Crash
  4. NSNotification Crash
  5. NSNull Crash
  6. NSTimer Crash
  7. 野指针 Crash
DESC
  s.homepage         = 'https://github.com/ValiantCat/XXShield'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'ValiantCat' => '519224747@qq.com' }
  s.source           = { :git => 'https://github.com/ValiantCat/XXShield.git', :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.module_map = 'XXShield/XXShield.modulemap'
  s.public_header_files   = 'XXShield/Classes/*.h'
  s.private_header_files = 'XXShield/Classes/template/*.h'
  s.source_files          = "XXShield/Classes/*/*.{h,m,mm}", "XXShield/Classes/*.{h,m,mm}"
  s.requires_arc =
  ['XXShield/Classes/*.m',
  'XXShield/Classes/FoundationContainer/*.m',
  'XXShield/Classes/KVO/*.m',
  'XXShield/Classes/NSTimer/*.m',
  'XXShield/Classes/Notification/*.m',
  'XXShield/Classes/NSNull/*.m',
  'XXShield/Classes/Record/*.m',
  'XXShield/Classes/SmartKit/*.m',
  'XXShield/Classes/Swizzle/*.m',
  'XXShield/Classes/DanglingPointerShield/ForwordingCenterForDanglingPoint.m',
  'XXShield/Classes/DanglingPointerShield/XXDanglingPonterClassService.m'
  ]
  # non_arc_files = "XXShield/Classes/DanglingPointerShield/NSObject+DanglingPointer.m" , "XXShield/Classes/DanglingPointerShield/*.h"
  s.pod_target_xcconfig = {
    'CLANG_WARN_STRICT_PROTOTYPES' => 'NO',
    'SWIFT_VERSION' => '3.2'
  }
  
#  s.dependency 'libextobjc'
#  s.dependency 'Crashlytics'
end
