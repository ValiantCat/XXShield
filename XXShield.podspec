#
# Be sure to run `pod lib lint XXShield.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XXShield'
  s.version          = '0.1.0'
  s.summary          = 'Avoid Crash'



  s.description      = <<-DESC
1.
1.
1.
                       DESC

  s.homepage         = 'https://github.com/ValiantCat/XXShield'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ValiantCat' => '519224747@qq.com' }
  s.source           = { :git => 'https://github.com/ValiantCat/XXShield.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'

  s.source_files = 'XXShield/Classes/**/*'

  # s.resource_bundles = {
  #   'XXShield' => ['XXShield/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'


   s.dependency 'libextobjc'
   s.dependency 'Crashlytics'
end
