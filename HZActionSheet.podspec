
Pod::Spec.new do |s|

  s.name         = "HZActionSheet"
  s.version      = "2.5.1"
  s.summary      = "ActionSheet like WeiXin"
  s.homepage     = "http://github.com/HistoryZhang/HZActionSheet"
  s.license      = "MIT"
  s.author       = { "HistoryZhang" => "history_zq@foxmail.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/HistoryZhang/HZActionSheet.git", :tag => "1.0.0" }
  s.source_files  = "HZActionSheet/*.{h,m}"
  s.requires_arc = true
  s.dependency 'Masonry', :git => 'https://arbitrary/location'
end
