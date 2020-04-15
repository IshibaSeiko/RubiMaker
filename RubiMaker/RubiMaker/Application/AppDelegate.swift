//
//  AppDelegate.swift
//  RubiMaker
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import UIKit
import XCGLogger

let log: XCGLogger? = {
    #if PRODUCT
    return nil

    #else
    let log = XCGLogger.default
    log.setup(level: .debug,
              showThreadName: true,
              showLevel: true,
              showFileNames: true,
              showLineNumbers: true,
              writeToFile: nil)
    return log
    #endif
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

