require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-fan"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/chro0611/react-native-fan.git", :tag => "#{s.version}" }
  s.dependency     "React"
  s.dependency     "FBAudienceNetwork"

  s.source_files = "ios/**/*.{h,m,mm,swift}"
end
