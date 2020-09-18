//
//  AppDelegate.swift
//  XCWebDemo
//
//  Created by diff on 2020/7/20.
//  Copyright © 2020 diff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        XCWebViewH5CoursewareMiddleware.register()
        return true
    }
}

