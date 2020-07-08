Pod::Spec.new do |s|

  s.name         = "AwsSign"
  s.version      = "0.4.0"
  s.summary      = "Swift library for signing AWS URLRequests"
  s.homepage     = "https://github.com/nikola-mladenovic/AwsSwiftSign"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = { "Nikola Mladenovic" => "nikola@mladenovic.biz" }
  s.source       = { :git => "https://github.com/nikola-mladenovic/AwsSwiftSign.git", :tag => s.version.to_s }
  s.source_files = 'Source/*.swift'
  s.swift_version = "5.2"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.2' }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.2'

  s.dependency 'CryptoSwift', '~> 1.3'

end
