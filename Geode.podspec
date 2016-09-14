Pod::Spec.new do |s|
  s.name                = "Geode"
  s.version             = "1.0.0"
  s.summary             = "Location management made easy."

  s.description         = <<-DESC
                          Geode is a Swift library that simplifies managing location access.
                          DESC

  s.homepage            = "https://github.com/Raizlabs/Geode"
  s.license             = { :type => "MIT", :file => "LICENSE" }

  s.authors             = { "John Watson" => "john.watson@raizlabs.com", "Raizlabs" => nil }
  s.social_media_url    = "http://twitter.com/Raizlabs"

  s.platform            = :ios, "9.0"
  s.source              = { :git => "https://github.com/Raizlabs/Geode.git", :tag => "v#{s.version}" }
  s.source_files        = "Source/**/*.{h,swift}"
  s.requires_arc        = true

  s.frameworks          = "CoreLocation"
end
