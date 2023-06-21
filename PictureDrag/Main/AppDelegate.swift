//
//  AppDelegate.swift
//  PictureDrag
//
//  Created by Ulian on 20.05.2023.
//

import UIKit
/**
 I removed SceneDelegate from the project, removed 'Application Scene Manifest' from Info.plist and manually adding root view controller
 from application(_: UIApplication, didFinishLaunchingWithOptions :) to gain more control over screens as it should be in VIPER
 */
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? // in UIApplicationDelegate
    var appDependencies = YNAppDependencies()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appDependencies.installRootViewControllerIntoWindow(window: window)
        
        return true
    }
}

