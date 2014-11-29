desc "Run the test suite"

task :test do
  build = "xcodebuild \
    -project ScrollingNavbarDemo/ScrollingNavbarDemo.xcodeproj \
    -scheme ScrollingNavbarDemo \
    -sdk iphonesimulator -destination 'name=iPhone 6'"
  system "#{build} build | xcpretty --color"  
end

task :default => :test


