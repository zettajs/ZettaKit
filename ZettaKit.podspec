Pod::Spec.new do |s|
  s.name             = "ZettaKit"
  s.version          = "0.0.5"
  s.summary          = "A Reactive Hypermedia Client for the Zetta HTTP API."
  s.description      = <<-DESC
                        This library allows you to harness the power of Reactive Programming to interact with the Zetta HTTP API.
                        DESC
  s.homepage         = "https://github.com/zettajs/ZettaKit"
  s.license          = 'MIT'
  s.author           = { "Matthew Dobson" => "matt@apigee.com" }
  s.source           = { :git => "https://github.com/zettajs/ZettaKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zettajs'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ZettaKit' => ['Pod/Assets/*.png']
  }
  s.dependency 'ReactiveCocoa', '2.4.7'
  s.dependency 'SocketRocket', '0.4'
  s.libraries = 'z'
end
