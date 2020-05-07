
Pod::Spec.new do |spec|


  spec.name         = "MMSandBoxHTTP"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of MMSandBoxHTTP."

  spec.description  = <<-DESC
                 基础工具库
                   DESC

  spec.homepage     = "https://github.com/z415073783/MMLibrary.git"

  # spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "The MIT License (MIT)" }

  spec.author             = { "zengliangmin" => "415073783@qq.com" }

  spec.platform     = :ios, "8.0"
  spec.ios.deployment_target = '8.0'


  spec.source       = { :git => "git@github.com:z415073783/MMLibrary.git", :tag => spec.version }

  spec.vendored_frameworks = "Build/*.framework"

  # spec.source_files  = "MMLibrary"
  # spec.exclude_files = "MMLibrary/Info.plist"



  spec.libraries = "z"

end
