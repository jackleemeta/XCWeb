//
//  XCWebViewMiddlewareRegistry.swift
//  XCWebDemo
//
//  Created by diff on 2020/6/8.
//  Copyright © 2020 diff. All rights reserved.
//

import WebViewJavascriptBridge

public typealias XCJBHandler = (_ webview: XCWebView, _ context: XCContext?, _ data: Any?, _ wvjbHandler: @escaping WVJBResponseCallback) -> ()

/// 全局Native和WebView交互中间件注册中心
public class XCWebViewMiddlewareRegistry {
    
    static var handlerMap = [String: XCJBHandler]()
    
    /// 注册JSBridge
    /// - Parameters:
    ///   - handlerName: JSBridge名称
    ///   - handler: 句柄
    public class func registerHandler(_ handlerName: String,
                               handler: @escaping XCJBHandler) {
        handlerMap[handlerName] = handler
    }
    
    /// 反注册JSBridge
    /// - Parameters:
    ///   - handlerName: JSBridge名称
    ///   - handler: 句柄
    public class func unregisterHandler(_ handlerName: String,
                                 handler: @escaping XCJBHandler) {
        handlerMap.removeValue(forKey: handlerName)
    }
    
}
