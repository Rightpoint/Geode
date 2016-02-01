COLORS_IN       = "Example/colors.txt"
COLORS_OUT      = "Example/Extensions/UIColor+Appearance.swift"
DESTINATION     = "platform=iOS Simulator,name=iPhone 6s Plus"
EXAMPLE         = "Example.xcodeproj"
PROJECT         = "Geode.xcodeproj"
SCHEME          = "Geode"
SDK             = "iphonesimulator9.2"
WORKSPACE       = "Geode.xcworkspace"

#
# Clean
#

task :clean do
  sh("xcodebuild -workspace '#{WORKSPACE}' -scheme '#{SCHEME}' -sdk '#{SDK}' -destination '#{DESTINATION}' -configuration Release ONLY_ACTIVE_ARCH=NO clean | xcpretty") rescue nil
  sh("xcodebuild -workspace '#{WORKSPACE}' -scheme '#{TEST_SCHEME}' -sdk '#{SDK}' -destination '#{DESTINATION}' -configuration Release ONLY_ACTIVE_ARCH=NO clean | xcpretty") rescue nil
end

#
# Build
#

task :build => :clean do
  sh("xcodebuild -workspace '#{WORKSPACE}' -scheme '#{SCHEME}' -sdk '#{SDK}' -destination '#{DESTINATION}' -configuration Release ONLY_ACTIVE_ARCH=NO build | xcpretty") rescue nil
end

#
# Test
#

task :test => :clean do
  sh("xcodebuild -workspace '#{WORKSPACE}' -scheme '#{SCHEME}' -sdk '#{SDK}' -destination '#{DESTINATION}' -configuration Debug ONLY_ACTIVE_ARCH=NO build test | xcpretty") rescue nil
end

#
# Sync
#

task :sync do
  sh("synx #{PROJECT}") rescue nil
  sh("synx #{EXAMPLE}") rescue nil
end

#
# Colors
#

task :colors do
  sh("swiftgen colors #{COLORS_IN} -o #{COLORS_OUT}")
end

#
# Utils
#

task :usage do
  puts "Usage:"
  puts "  rake build    - build for simulator"
  puts "  rake test     - build for simulator and run tests"
  puts "  rake clean    - clean project build artifacts"
  puts "  rake sync     - synchronize directory structure with project files"
  puts "  rake colors   - generate example project color definitions with SwiftGen"
  puts "  rake usage    - print this message"
end

#
# Default
#

task :default => 'usage'
