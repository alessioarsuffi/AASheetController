#
# Be sure to run `pod lib lint AASheetController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'AASheetController'
s.version          = '0.1.1'
s.summary          = 'Replace apple UIAlertController with access to device photo library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
AASheetController is an highly customizable ViewController that aim to simplify access to device photo library using photos framework, it has the same appearance of apple UIAlertController with .sheet style.
DESC

s.homepage         = 'https://github.com/alessioarsuffi/AASheetController'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Alessio Arsuffi' => 'alessio.arsuffi@gmail.com' }
s.source           = { :git => 'https://github.com/alessioarsuffi/AASheetController.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.3'

s.source_files = 'AASheetController/Classes/**/*'

# s.resource_bundles = {
#   'AASheetController' => ['AASheetController/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'UIKit', 'Photos'
end
