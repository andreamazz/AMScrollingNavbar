desc "Run the test suite"

task :test do
  Dir.chdir 'Demo' do
    system "pod update"
  end

  build = "xcodebuild \
    -workspace Demo/ScrollingNavbarDemo.xcworkspace \
    -scheme ScrollingNavbarDemo \
    -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4'"
  system "#{build} test | xcpretty --test --color"  
end

task :default => :test


