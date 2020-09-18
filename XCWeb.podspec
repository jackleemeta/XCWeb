Pod::Spec.new do |s|

    s.name = "XCWeb"
    s.version = "0.0.1"
    s.summary = "自定义WebView"
    s.description = "自定义WebView"
    s.homepage = "https://github.com/jackleemeta/XCWeb.git"
    s.license = "MIT"
    s.platform = :ios
    s.author = { "jackleemeta" => "jackleemeta@outlook.com" }
    s.requires_arc = true
    s.ios.deployment_target = "9.0"

    s.swift_version = '5.0'

    s.source = { :git => "https://github.com/jackleemeta/XCWeb.git", :tag => s.version }
    
    s.source_files  = 'XCWeb/**/*.swift'

    s.static_framework = true
    s.dependency 'WebViewJavascriptBridge'
    s.dependency 'MBProgressHUD', '1.1.0'

end
