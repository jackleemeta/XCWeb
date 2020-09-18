//
//  XCWebViewJSBridgeManager.swift
//  XCWebDemo
//
//  Created by diff on 2020/6/8.
//  Copyright © 2020 diff. All rights reserved.
//

import WebKit
import WebViewJavascriptBridge

/// WebView的JSBridge管理者
class XCWebViewJSBridgeManager {
    
    /// init方法
    /// - Parameters:
    ///   - webView: webView
    ///   - webViewDelegate: webView代理
    ///   - context: 上下文
    init(webView: WKWebView,
         webViewDelegate: WKNavigationDelegate,
         context: XCContext?) {
        bridge = WKWebViewJavascriptBridge(for: webView)
        bridge.setWebViewDelegate(webViewDelegate)
        self.webView = webView as? XCWebView
        self.context = context
    }
    
    /// webView注册需要注册的jsb
    func registerHandlers() {
        XCWebViewMiddlewareRegistry.handlerMap.forEach { [weak self] key, value in
            guard let `self` = self else { return }
            self.registerHandler(key, xcJBHandler: value)
        }
    }
    
    /// webView删除需要注册的jsb
    func removeHandlers() {
        XCWebViewMiddlewareRegistry.handlerMap.keys.forEach { [weak self] key in
            guard let `self` = self else { return }
            self.bridge.removeHandler(key)
        }
    }
    
    /// Native 调用 Web
    /// - Parameters:
    ///   - handlerName: 方法名
    ///   - data: 入参
    ///   - responseCallback: 句柄
    func callHandler(_ handlerName: String,
                     data: Any?,
                     responseCallback: WVJBResponseCallback?) {
        bridge.callHandler(handlerName, data: data, responseCallback: responseCallback)
    }
    
    // MARK: - Private Method
    
    /// 注册事件 + 绑定XCJBHandler
    /// - Parameters:
    ///   - handlerName: 方法名
    ///   - xcJBHandler: XCJBHandler句柄
    private func registerHandler(_ handlerName: String,
                                 xcJBHandler: @escaping XCJBHandler) {
        bridge.registerHandler(handlerName) { [weak self] data, responseCallBack in
            guard let `self` = self else { return }
            xcJBHandler(self.webView!, self.context, data, responseCallBack!)
        }
    }
    
    deinit {
        debugPrint("XCWebViewJSBridgeManager Denited")
    }
    
    private let bridge: WKWebViewJavascriptBridge
    private weak var webView: XCWebView?
    private weak var context: XCContext?
}
