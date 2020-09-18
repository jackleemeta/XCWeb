//
//  XCWebView.swift
//  XCWebDemo
//
//  Created by diff on 2020/6/8.
//  Copyright © 2020 diff. All rights reserved.
//

import WebKit
import MBProgressHUD

/// Web配置类
public class XCWebIntent {
    
    // MARK: - Builders
    
    /// XCWeb建造者 - 普通模式
    /// - Parameter builderBlock: 建造回调
    /// - Returns: XCWebIntent 目的对象
    public class func createWithCommonBuilder(_ builderBlock: XCWebViewCommonBuilder.XCWebViewCommonBuilderBlock) -> XCWebIntent {
        let builder = XCWebViewCommonBuilder()
        builderBlock(builder)
        return builder.build()
    }
    
    /// XCWeb建造者 - HTML模式
    /// - Parameter builderBlock: 建造回调
    /// - Returns: XCWebIntent 目的对象
    public class func createWithLocalHtmlBuilder(_ builderBlock: XCWebViewLocalHtmlBuilder.XCWebViewLocalHtmlBuilderBlock) -> XCWebIntent {
        let builder = XCWebViewLocalHtmlBuilder()
        builderBlock(builder)
        return builder.build()
    }
    
    /// 添加到父视图
    /// - Parameter superView: 父视图
    public func add(onSuperView superView: UIView) {
        attach(toSuperView: superView) { [weak superView] aView in
            guard let `superView` = superView else { return }
            superView.addSubview(aView)
        }
    }
    
    /// 插入到父视图层级
    /// - Parameter superView: 父视图
    public func insert(toSuperView superView: UIView,
                       at index: Int) {
        attach(toSuperView: superView) { [weak superView] aView in
            guard let `superView` = superView else { return }
            superView.insertSubview(aView,
                                    at: index)
        }
    }
    
    /// 调整WebView位置
    /// - Parameter frame: 新frame
    public func reframe(frame: CGRect) {
        webView?.frame = frame
    }
    
    /// 隐藏
    /// - Parameter hidden: hidden
    public func hide(_ hidden: Bool) {
        webView?.isHidden = hidden
        superViewOfHud?.isHidden = hidden
    }
    
    /// 允许 / 禁止 和webView交互
    /// - Parameter enabled: enabled
    public func interact(_ enabled: Bool) {
        webView?.isUserInteractionEnabled = enabled
    }
    
    /// 释放
    public func dispose() {
        guard let webView = webView else { return }
        webView.removeFromSuperview()
    }
    
    /// JSBridge管理者
    var jsbManager: XCWebViewJSBridgeManager? {
        return webView?.jsbManager
    }
    
    deinit {
        debugPrint("XCWebIntent Deinit")
    }
    
    // MARK: - Private Method
    
    private func attach(toSuperView superView: UIView,
                        attachCallBack: @escaping ((UIView)->())) {
        guard let webView = webView else { return }
        if webView.isLoading {
            
            let superViewOfHud = UIView(frame: webView.frame)
            self.superViewOfHud = superViewOfHud
            attachCallBack(superViewOfHud)
            
            MBProgressHUD.show(on: superViewOfHud)
            webView.didFinishCallBack = { [weak self, weak webView, weak superViewOfHud] aBool in
                guard let `self` = self else { return }
                
                if let `superViewOfHud` = superViewOfHud {
                    MBProgressHUD.hide(for: superViewOfHud, animated: true)
                    superViewOfHud.removeFromSuperview()
                }
                
                guard let `webView` = webView else { return }
                attachCallBack(webView)
                self.didFinishCallBack?(aBool)
            }
        } else {
            attachCallBack(webView)
            didFinishCallBack?(true)
        }
    }
    
    fileprivate weak var superViewOfHud: UIView?
    fileprivate var didFinishCallBack: ((Bool) -> ())?
    fileprivate var tapCallBack: (()->())? {
        didSet {
            webView?.tapCallBack = tapCallBack
        }
    }
    fileprivate var webView: XCWebView?
}

public class XCWebViewBaseBuilder {
    public var rect: CGRect!
    public var urlString: String!
    public var context: XCContext?
    public var didFinishCallBack: ((Bool) -> ())?
    public var tapCallBack: (() -> ())?
}

/// 加载URL的WebView建造者
public class XCWebViewCommonBuilder: XCWebViewBaseBuilder  {
    
    public typealias XCWebViewCommonBuilderBlock = (XCWebViewCommonBuilder) -> ()
    
    fileprivate func build() -> XCWebIntent {
        let webView = XCWebView(frame: rect,
                                context: context)
        
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        webView.load(request)
        
        let intent = XCWebIntent()
        intent.webView = webView
        return intent
    }
    
    deinit {
        debugPrint("XCWebViewCommonBuilder Deinit")
    }
}

/// 加载Html的WebView建造者
public class XCWebViewLocalHtmlBuilder: XCWebViewBaseBuilder {
    
    public typealias XCWebViewLocalHtmlBuilderBlock = (XCWebViewLocalHtmlBuilder) -> ()
    
    var queryString: String = ""
    
    fileprivate func build() -> XCWebIntent {
        let webView = XCWebView(frame: rect,
                                context: context)
        
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        
        let baseURL = URL(fileURLWithPath: urlString)
        let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let needAccessURL = URL(fileURLWithPath: directory)
        webView.loadFileURL(baseURL,
                            allowingReadAccessTo: needAccessURL)
        
        let intent = XCWebIntent()
        intent.webView = webView
        intent.didFinishCallBack = didFinishCallBack
        intent.tapCallBack = tapCallBack
        return intent
    }
    
    deinit {
        debugPrint("XCWebViewLocalHtmlBuilder Deinit")
    }
}

/// 一个面向事件的webView
public class XCWebView: WKWebView {
    
    // MARK: - Private Method
    fileprivate init(frame: CGRect,
                     context: XCContext?) {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        if #available(iOS 13.0, *) {
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        }
        super.init(frame: frame, configuration: configuration)
        backgroundColor = UIColor(white: 55/255.0, alpha: 1)
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.context = context
        uiDelegate = delegation
        navigationDelegate = delegation
        jsbManager = XCWebViewJSBridgeManager(webView: self,
                                              webViewDelegate: delegation,
                                              context: context)
        jsbManager.registerHandlers()
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let isInside = self.point(inside: point, with: event)
        if isInside {
            if lastPoint != point {
                lastPoint = point
                tapCallBack?()
            }
        }
        return super.hitTest(point, with: event)
    }
    
    // MARK: - Private API
    
    deinit {
        jsbManager.removeHandlers()
        debugPrint("XCWebView Deinited")
    }
    
    private var lastPoint: CGPoint?
    fileprivate var delegation = XCWebViewDelegate()
    fileprivate var jsbManager: XCWebViewJSBridgeManager!
    fileprivate var context: XCContext?
    fileprivate var didFinishCallBack: ((Bool) -> ())?
    fileprivate var tapCallBack: (() -> ())?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// WKNavigationDelegate、WKUIDelegate 代理者
class XCWebViewDelegate: NSObject {
    
    deinit {
        debugPrint("XCWebViewDelegate Deinited")
    }
    
}

extension XCWebViewDelegate: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#file, #function)
    }
    
    func webView(_ webView: WKWebView,
                 didCommit navigation: WKNavigation!) {
        debugPrint(#file, #function)
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        let xcWebView = (webView as? XCWebView)
        xcWebView?.didFinishCallBack?(true)
        xcWebView?.didFinishCallBack = nil
        debugPrint(#file, #function)
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        let xcWebView = (webView as? XCWebView)
        xcWebView?.didFinishCallBack?(false)
        xcWebView?.didFinishCallBack = nil
        debugPrint(#file, #function)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint(#file, #function)
        decisionHandler(.allow)
    }
}

extension XCWebViewDelegate: WKUIDelegate { }

extension MBProgressHUD {
    private struct AssociatedKeys {
        static var HUDName = "HUDName"
    }
    
    class func show(on superView: UIView) {
        let hud = MBProgressHUD()
        superView.addSubview(hud)
        objc_setAssociatedObject(self, &AssociatedKeys.HUDName, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        hud.removeFromSuperViewOnHide = true
        hud.mode = MBProgressHUDMode.indeterminate
        hud.contentColor    = .white
        hud.bezelView.color = .black
        hud.show(animated: true)
    }
    
    class func hide(on superView: UIView) {
        if let hud = objc_getAssociatedObject(self, &AssociatedKeys.HUDName) as? MBProgressHUD {
            hud.hide(animated: true)
            objc_setAssociatedObject(self, &AssociatedKeys.HUDName, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
