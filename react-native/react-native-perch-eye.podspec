Pod::Spec.new do |s|
  s.name         = 'react-native-perch-eye'
  s.version      = '0.0.2'
  s.summary      = 'React Native module for PerchEye iOS SDK'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Ruslan Horbachevskyi' => 'ruslan.horbachevskyi@onix-systems.com' }
  s.homepage     = 'https://github.com/Onix-Systems/PerchEye-SDK-Multiplatform/tree/main/react-native#readme'
  s.platform     = :ios, '12.0'
  s.source       = { :path => '.' }

  s.source_files  = 'ios/**/*.{h,m,mm,swift}'
  s.public_header_files = 'ios/**/*.{h}'

  s.preserve_paths = 'PerchEyeSDK-iOS.xcframework'
  s.vendored_frameworks = 'ios/Frameworks/PerchEyeSDK.xcframework'

  s.dependency 'React'
  s.swift_version = '5.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
end