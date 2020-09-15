#
# Be sure to run `pod lib lint SVCircularSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SVCircularSlider'
  s.version          = '0.1.2'
  s.summary          = 'Interactive and Customizeble Circular Slider'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'Interactive and Customizeble Circular Slider, which returns a percentage value'
                       DESC

  s.homepage         = 'https://github.com/stevalsecchi98/SVCircularSlider'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stevalsecchi98' => 'Stevalsecchi98@gmail.com' }
  s.source           = { :git => 'https://github.com/stevalsecchi98/SVCircularSlider.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.source_files = 'Source/**/*.swift'
  
  # s.resource_bundles = {
  #   'SVCircularSlider' => ['SVCircularSlider/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
