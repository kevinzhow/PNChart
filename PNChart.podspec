Pod::Spec.new do |s|
  s.name         = "PNChart"
  s.version      = "0.6.0"
  s.summary      = "A simple and beautiful chart lib with animation used in Piner for iOS"

  s.homepage     = "https://github.com/kevinzhow/PNChart"
  s.screenshots  = "https://github-camo.global.ssl.fastly.net/ea8565b7a726409d5966ff4bcb8c4b9981fb33d3/687474703a2f2f646c2e64726f70626f7875736572636f6e74656e742e636f6d2f752f313539393636322f706e63686172742e706e67"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Kevin" => "kevinchou.c@gmail.com" }

  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/moflo/PNChart.git" }

  s.ios.dependency 'UICountingLabel', '~> 1.0.0'

  s.source_files = 'PNChart/**/*.{h,m}'
  s.public_header_files = 'PNChart/**/*.h'
  s.frameworks   = 'CoreGraphics', 'UIKit', 'Foundation', 'QuartzCore'
  s.requires_arc = true
end
