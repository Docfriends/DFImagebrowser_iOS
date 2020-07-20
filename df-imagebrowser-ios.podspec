#
# Be sure to run `pod lib lint df-imagebrowser-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'df-imagebrowser-ios'
  s.version          = '0.1.8'
  s.summary          = '닥프렌즈의 이미지 브라우져 라이브러리'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
이미지들을 다운받고 다운받은 이미지들을 볼수 있는 라이브러리
                       DESC

  s.homepage         = 'https://github.com/Docfriends/df-imagebrowser-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Docfriends' => 'apps@docfriends.com' }
  s.source           = { :git => 'https://github.com/Docfriends/df-imagebrowser-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'df-imagebrowser-ios/Classes/**/*'
  
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'df-imagebrowser-ios' => ['df-imagebrowser-ios/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
