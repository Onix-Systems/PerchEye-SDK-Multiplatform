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
    'Classes/**/*'
  ]
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
  s.swift_version = '5.0'
end