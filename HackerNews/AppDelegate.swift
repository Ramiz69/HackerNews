//
//  AppDelegate.swift
//  HackerNews
//
//  Created by Рамиз Кичибеков on 26.02.2018.
//  Copyright © 2018 Рамиз Кичибеков. All rights reserved.
//

import UIKit
import HackerNewsKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard
            let storyIDString = userActivity.userInfo!["kCSSearchableItemActivityIdentifier"] as? String,
            let storyID = Int(storyIDString),
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            else {
            return true
        }
        let operation = OperationGetStory(storyID)
        operation.completionBlock = {
            let storyViewController = navigationController.storyboard?.instantiateViewController(withIdentifier: String(describing: StoryViewController.self)) as! StoryViewController
            storyViewController.model = operation.story
            self.executeOnMainThread {
                navigationController.pushViewController(storyViewController, animated: true)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        OperationGetStoryImage.imageCache.removeAllObjects()
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // MARK: - Shortcut Items
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }
    
    func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard
            let selectIndexItem = shortcutItem.userInfo?["index"] as? Int,
            let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let rootViewController = navigationController.viewControllers.first as? StoriesViewController
            else {
                return false
        }
        rootViewController.contentType = ContentType(rawValue: selectIndexItem) ?? .newStories
        window?.rootViewController = navigationController
        return true
    }
}

