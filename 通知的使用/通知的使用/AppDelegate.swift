//
//  AppDelegate.swift
//  通知的使用
//
//  Created by 史祺淳 on 2017/7/7.
//  Copyright © 2017年 史祺淳. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// 设置通知的category
    func setCategories() {
        
        /** 1、创建action */
        
        // 可输入文本的action
        let textInputAction = UNTextInputNotificationAction(identifier: "text.input", title: "回复", options: [], textInputButtonTitle: "发送", textInputPlaceholder: "请在这里输入文字进行回复")
        
        // 推送下一条
        let nextAction = UNNotificationAction(identifier: "next.action", title: "推送下一条", options: [])
        
        // 停止推送
        let stopAction = UNNotificationAction(identifier: "stop.action", title: "停止推送", options: [])
        
        // 稍后再推送
        let sentLaterAction = UNNotificationAction(identifier: "sent.later.action", title: "稍后推送", options: [])
        
        
        
        /** 2、创建category */
        
        // 创建第一个category
        let sendCategory = UNNotificationCategory(identifier: "send.category", actions: [stopAction], intentIdentifiers: [], options: [])
        
        // 创建第二个category
        let otherCategory = UNNotificationCategory(identifier: "other.category", actions: [nextAction, textInputAction, sentLaterAction, stopAction], intentIdentifiers: [], options: [])
        
        
        
        /** 3、在通知中心设置category */
        
        // 设置category
        UNUserNotificationCenter.current().setNotificationCategories([sendCategory, otherCategory])
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 注册可交互通知
        setCategories()
        
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


}

