Pod::Spec.new do |s|
  s.name          = "AMScrollingNavbar"
  s.version       = "5.7.0"
  s.summary       = "A custom UINavigationController that enables the scrolling of the navigation bar alongside the scrolling of an observed content view"
  s.description   = <<-DESC
                     A custom UINavigationController that enables the scrolling of the
                     navigation bar alongisde the scrolling of the observed view's content.
                    DESC
  s.homepage      = "https://github.com/andreamazz/AMScrollingNavbar"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Andrea Mazzini" => "andrea.mazzini@gmail.com" }
  s.source        = { :git => "https://github.com/andreamazz/AMScrollingNavbar.git", :tag => s.version }
  s.platform      = :ios, '8.0'
  s.source_files  = 'Source/*.swift'
  s.requires_arc  = true
  s.swift_version = '5.0'
  s.social_media_url = 'https://twitter.com/theandreamazz'
end
