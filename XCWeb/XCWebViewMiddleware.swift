//
//  XCWebViewMiddleware.swift
//  XCWebDemo
//
//  Created by diff on 2020/6/10.
//  Copyright © 2020 diff. All rights reserved.
//

import WebViewJavascriptBridge

open class XCWebViewMiddleware {
    public class func callHander(_ handlerName: String,
                                 data: Any?,
                                 inXCWebIntent xcWebIntent: XCWebIntent?,
                                 responseCallback: WVJBResponseCallback? = nil) {
        xcWebIntent?.jsbManager?.callHandler(handlerName,
                                             data: data,
                                             responseCallback: responseCallback)
    }
}
