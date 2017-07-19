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


  s.ios.deployment_target = '7.0'

   s.source_files = 'XXShield/Classes/**/*'
   s.requires_arc = true

  # s.default_subspec = 'source'
  #public
    # s.subspec 'source' do |source|
    #
    #
    #   source.dependency 'XXShield/SDK'
    #   source.dependency 'XXShield/FoundationContainer'
    #   source.dependency 'XXShield/KVO'
    #   source.dependency 'XXShield/Notification'
    #   source.dependency 'XXShield/NSNull'
    #   source.dependency 'XXShield/NSTimer'
    #   source.dependency 'XXShield/SmartKit'
    #   source.dependency 'XXShield/DanglingPointerXXShield'
    #   source.dependency 'XXShield/Record'
    #   source.dependency 'XXShield/Swizzling'
    # end

  #  private
    # s.subspec 'SDK' do |sdk|
    #   sdk.source_files = 'XXShield/Classes/*'
    #   sdk.requires_arc = true
    # end
    # s.subspec 'FoundationContainer' do |foundationContainer|
    #   foundationContainer.source_files = 'XXShield/Classes/FoundationContainer/*'
    #   foundationContainer.requires_arc = true
    # end
    # s.subspec 'KVO' do |kvo|
    #   kvo.source_files = 'XXShield/Classes/KVO/*'
    #   kvo.requires_arc = true
    # end
    # s.subspec 'Notification' do |notification|
    #   notification.source_files = 'XXShield/Classes/Notification/*'
    #   notification.requires_arc = true
    # end
    # s.subspec 'NSNull' do |nSNull|
    #   nSNull.source_files = 'XXShield/Classes/XXShield/NSNull/*'
    #   nSNull.requires_arc = true
    # end
    # s.subspec 'NSTimer' do |nSTimer|
    #   nSTimer.source_files = 'XXShield/Classes/NSTimer/*'
    #   nSTimer.requires_arc = true
    # end
    # s.subspec 'SmartKit' do |smartKit|
    #   smartKit.source_files = 'XXShield/Classes/SmartKit/*'
    #   smartKit.requires_arc = true
    # end
    # s.subspec 'DanglingPointerXXShield' do |danglingPointerXXShield|
    #   danglingPointerXXShield.source_files = 'XXShield/Classes/DanglingPointerXXShield/*'
    #   danglingPointerXXShield.requires_arc = ['XXShield/Classes/DanglingPointerXXShield/XXDanglingPonterClassService.m',
    #     'XXShield/Classes/DanglingPointerXXShield/ForwordingCenterForDanglingPoint.m'
    #   ]
    # end
    # s.subspec 'Record' do |record|
    #   record.source_files = 'XXShield/Classes/Record/*'
    #   record.requires_arc = true
    # end
    # s.subspec 'Swizzling' do |swi|
    #   swi.source_files = 'XXShield/Classes/Swizzle/*'
    #   swi.requires_arc = true
    # end


   s.dependency 'libextobjc'
   s.dependency 'Crashlytics'
end
