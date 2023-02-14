Pod::Spec.new do |s|
  s.name             = 'AORequest'
  s.version          = '0.1.0'
  s.summary          = 'A Light http request helper for iOS.'
  s.homepage         = 'https://github.com/Caplord/AORequest'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Air One' => 'masson.erwan1@gmail.com' }
  s.source           = { :git => 'https://github.com/Caplord/AORequest.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.7'
  s.source_files = 'Sources/AORequest/**/*'
end
