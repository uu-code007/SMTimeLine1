
Pod::Spec.new do |s|


  s.name         = "SMTimeLine"
  s.version      = "0.0.3"
  s.summary      = "SMTimeLine."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = "SMTimeLine，时间回放条，放大缩小，标记"

  s.homepage     = "https://github.com/iossun/SMTimeLine1"

  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "sunmu" => "ios_sunmu@icloud.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/iossun/SMTimeLine1.git", :tag => "0.0.3" }
  s.source_files  = "SMTimeLine/Classes/*.{h,m}"



end
