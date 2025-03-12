#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint desk_zoho_chat.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'desk_zoho_chat'
  s.version          = '0.0.1'
  s.summary          = 'Zoho Desk Support Plugin.'
  s.description = <<-DESC
  A Flutter plugin to integrate Zoho Desk Support in your Flutter app. It provides an easy-to-use API for communicating with the Zoho Desk platform to provide in-app chat functionality for customer support.
  DESC
  s.homepage         = 'https://github.com/Ibnyahyah/desk_zoho_chat'
  s.license          = { :type=>'Modified BSD License',:file => '../LICENSE' }
  s.author           = { 'Whitecode' => '1+yahyahridwan665@gmail.com' }
  s.source = { :git => 'https://github.com/Ibnyahyah/desk_zoho_chat.git', :tag => s.version.to_s }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
