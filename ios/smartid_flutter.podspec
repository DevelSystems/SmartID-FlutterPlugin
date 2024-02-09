#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint smartid_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'smartid_flutter'
  s.version          = '1.0.0'
  s.summary          = 'SmartId Bridge for Flutter.'
  s.description      = <<-DESC
SmartId Bridge for Flutter.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Alejandro Ramirez' => 'jramirez@develsystems.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.ios.vendored_frameworks = "SmartId.xcframework"
  s.dependency 'Flutter'
  s.dependency 'KeychainAccess', '4.2.2'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
