# XCWeb

## CocoaPods引入

XCWeb（面向事件的WebView组件）

### 引入

- podfile
```
source 'https://cdn.cocoapods.org'
```

```
pod 'XCWeb'
```

- pod install

### Usage

- import
  - import XCWeb
  
- 初始化

```
xcWebIntent = XCWebIntent.createWithLocalHtmlBuilder { builder in
    let height = 10
    let width = 10
    builder.rect = CGRect(x: 0, y: 0, width: width, height: height)
    builder.urlString = "your url"
    let context = XCContext(object: self)
    builder.context = context
    builder.tapCallBack = { [weak self] in
        guard let `self` = self else { return }
        debugPrint("self = \(self) is not nil")
        // 点击事件
    }
}

xcWebIntent?.insert(toSuperView: view,
                    at: 0)
```

- 注册JS回调事件

```
class func registerAMClassLoadJsonHandler() {
    XCWebViewMiddlewareRegistry.registerHandler(kAHandlerName) { webView, context, data, responseCallBack in
        // webView
        // context 上下文
        // data h5返回的消息体
        // responseCallBack 回调H5句柄
    }
}

```

- 主动调用JS

```
XCWebViewBussinessMiddleware.callHander(kAHandlerName,
                                        data: msg,
                                        inXCWebIntent: xcWebIntent) { result in
                                         debugPrint("XCWebViewBussinessMiddleware callHander recived result in function => receivedMessage")
}
```
