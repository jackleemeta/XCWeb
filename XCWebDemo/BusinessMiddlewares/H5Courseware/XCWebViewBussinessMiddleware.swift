//
//  XCWebViewBussinessMiddleware.swift
//  XCWebDemo
//
//  Created by diff on 2020/6/8.
//  Copyright © 2020 diff. All rights reserved.
//

class XCWebViewBussinessMiddleware: XCWebViewMiddleware {

    /// 注册服务
    class func register() {
        registerkAHandlerName()
    }
    
    /// 注册 kAHandlerName 事件
    class func registerkAHandlerName() {
        XCWebViewMiddlewareRegistry.registerHandler(kAHandlerName) { webView, context, data, responseCallBack in
        }
    }
    
}
