Pod::Spec.new do |s|
  s.name             = 'perch_eye'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for PerchEye SDK'
  s.description      = <<-DESC
Flutter plugin for PerchEye face recognition SDK.
                       DESC
  s.homepage         = 'https://github.com/Onix-Systems/PerchEye-SDK-Multiplatform'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Onix Systems' => 'info@onix-systems.com' }
  
  s.source           = { :path => '.' }
  s.source_files = [
    'Classes/**/*',
    'Frameworks/PerchEyeFramework/**/*.{h,m,mm,swift}'
  ]
  s.public_header_files = [
    'Frameworks/PerchEyeFramework/**/*.h'
  ]

  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/Frameworks/PerchEyeFramework',
  }
  s.swift_version = '5.0'

  # Include the C++ library and headers
  s.libraries = 'c++'
  s.xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++'
  }
end