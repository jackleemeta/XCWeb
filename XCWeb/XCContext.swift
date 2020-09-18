//
//  XCContext.swift
//  XCWebDemo
//
//  Created by diff on 2020/6/10.
//  Copyright © 2020 diff. All rights reserved.
//

public class XCContext {
    public weak var object: AnyObject?
    
    public init(object: AnyObject?) {
        self.object = object
    }
    
    deinit {
        debugPrint("XCContext Deinited")
    }
}
