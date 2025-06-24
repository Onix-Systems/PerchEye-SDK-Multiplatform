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

  # Include only the plugin Swift code
  s.source_files = 'Classes/**/*'

  # Include the pre-built framework
  s.vendored_frameworks = 'Frameworks/PerchEyeFramework.framework'

  # Ensure TensorFlow headers are not exposed
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'HEADER_SEARCH_PATHS' => '$(inherited)',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/../.symlinks/plugins/perch_eye/ios/Frameworks'
  }

  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.swift_version = '5.0'

  # Exclude TensorFlow headers from being copied
  s.prepare_command = <<-CMD
    find Frameworks -name "*.h" -path "*/TensorFlowLiteC.xcframework/*" -delete || true
  CMD
end