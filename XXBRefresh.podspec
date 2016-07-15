Pod::Spec.new do |s|
  s.requires_arc = true
  s.name         = 'XXBRefresh'
  s.version      = '0.0.1'
  s.summary      = "20160415"
  s.homepage     = "https://github.com/sixTiger/XXBRefresh"
  s.license      = "MIT"
  s.authors      = { '杨小兵' => 'six_tiger@163.com' }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  //s.source       = { :git => "https://github.com/sixTiger/XXBRefresh.git", :tag => s.version }
  s.source       = { :git => "https://github.com/sixTiger/XXBRefresh.git"}
  s.public_header_files = 'XXBRefresh/XXBRefresh.h'
  s.source_files = 'XXBRefresh/XXBRefresh.h'
  s.requires_arc  = true

  s.subspec 'Others' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.source_files = 'XXBRefresh/Others/*.{h,m}'
    ss.public_header_files = 'XXBRefresh/Others/*.h'
  end
  s.subspec 'View' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.dependency 'XXBRefresh/Others'
    ss.source_files = 'XXBRefresh/View/*.{h,m}'
    ss.public_header_files = 'XXBRefresh/View/*.h'
  end
  s.resource_bundles = {
    'XXBRefresh' => ['XXBRefresh/Resources/*.png']
  }
end
