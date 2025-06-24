require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "react-native-perch-eye"
  s.version      = package["version"]
  s.summary      = "PerchEye React Native Bridge"
  s.homepage     = "https://example.com"
  s.license      = "MIT"
  s.author       = { "you" => "you@example.com" }
  s.source       = { :path => "." }
  s.source_files = "ios/**/*.{h,m,swift}"
  s.platform     = :ios, "12.0"
  s.swift_version = "5.0"
  s.dependency "React-Core"
end