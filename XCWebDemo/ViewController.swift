//
//  ViewController.swift
//  XCWebDemo
//
//  Created by diff on 2020/7/20.
//  Copyright © 2020 diff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var xcWebIntent: XCWebIntent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        
        
    }
    
    func launch() {
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
    }
    
    
    
}

