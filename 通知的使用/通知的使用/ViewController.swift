//
//  ViewController.swift
//  通知的使用
//
//  Created by 史祺淳 on 2017/7/7.
//  Copyright © 2017年 史祺淳. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    /// 用于标记通知权限(默认为false)
    var isGrantedNotificationAccess = false
    
    /// 用于更改通知的内容
    fileprivate var index = 0
    
    /// 用于更新即将显示通知的内容(body)
    let catchUp = ["还有这种事？", "不能让她跑了！赶紧起床追", "抱着衣服追...☺️☺️☺️", "边追边穿衣服...😱😱😱😱", "还好来得及，赶紧追！"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 获取通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            
            // 当用户点击“Allow”时，granted的值为true，
            // 当用户点击“Don't Allow”时，granted的值为false
            self.isGrantedNotificationAccess = granted
            
            // 如果没有获取到用户授权，就会执行下面的代码
            if !granted {
                
                // 可以考虑在这里执行一个弹窗，提示用户获取通知权限
                print("需要获取通知权限才能发送通知.")
            }
        }
        
        // 设置UNUserNotificationCenter的代理
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// 用于创建发送通知的请求, 并将其添加到通知中心
    func addNotification(_ identifier: String, _ content: UNMutableNotificationContent, _ trigger: UNNotificationTrigger?) {
        
        // 创建通知发送请求
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // 将通知发送请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("error adding notification: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    
    
    
    
    // MARK: - 发送通知
    @IBAction func sendNotifications(_ sender: UIButton) {
        
        // 如果获取到发送通知的权限
        if isGrantedNotificationAccess {
            
            // 创建通知的内容
            let content = UNMutableNotificationContent()
            
            // 设置通知默认提示音
            content.sound = UNNotificationSound.default()
            
            // 设置通知的标题
            // content.title = "紧急通知"
            // content.title = "难念的经"
            content.title = "The Sound of Silence"
            
            // 设置通知的内容
            // content.body = "起床啦！你老婆跟人跑了！😳😳😳😳😳"
            // content.body = "古装群像·香港电影·红颜乱入版"
            content.body = "Paul Simon & Garfunkel"
            
            // 设置categoryIdentifier
            content.categoryIdentifier = "send.category"
            
            /** 加载多媒体通知 */
            
            // 将标识符、文件名称和扩展名作为参数传递进去
            //            let attachement = notificationAttachment("send.video", "难念的经", "mp4")
             let attachement = notificationAttachment("send.music", "The Sound of Silence", "mp3")
            
            // 设置内容的attachments
            content.attachments = attachement
            
            /** 创建通知触发器 */
            let dateComponents: Set<Calendar.Component> = [.second, .minute, .hour]
            var date = Calendar.current.dateComponents(dateComponents, from: Date())
            date.second = date.second! + 3
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            
            // 创建发送通知请求的标识符
            let identifier = "message.yourWifeRanAway"
            
            // 创建发送通知其的请求，并且将其添加到通知中心
            addNotification(identifier, content, trigger)
        }
    }
    
    
    
    
    
    
    
    // MARK: - 又发通知
    @IBAction func otherNotifications(_ sender: UIButton) {
        
        // 如果获取到发送通知授权
        if isGrantedNotificationAccess {
            
            // 调用createNotificationContent
            let content = createNotificationContent()
            
            // 修改content的subtitle
            index += 1
            content.subtitle = "你老婆跑了\(index)次！🙄🙄🙄🙄🙄"
            
            // 创建通知触发器
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
            
            // 创建发送通知请求的标识符
            let identifier = "message.yourWifeRanAgain.\(index)"  // 因为更改了通知的内容，所以标识符也要修改
            // let identifier = "message.yourWifeRanAgain"
            
            // 创建发送通知其的请求，并且将其添加到通知中心
            addNotification(identifier, content, trigger)
        }
    }
    
    /// 创建通知的内容
    func createNotificationContent() -> UNMutableNotificationContent {
        
        // 创建通知内容
        let content = UNMutableNotificationContent()
        
        // 在App图标上显示通知数量
        content.badge = 5
        
        // 设置通知默认提示音
        content.sound = UNNotificationSound.default()
        
        // 设置通知标题
        content.title = "再次通知"
        // content.title = "来，屁股扭起来！"
        
        // 设置通知内容
        content.body = "再不起床，你老婆真跟人跑了！😂😂😂😂😂"
        // content.body = "脖子扭扭, 屁股扭扭, 早睡早起,咱们来做运动!😂😂😂"
        
        // 随机数
        let number = Int(arc4random_uniform(10000))
        
        // 设置本地通知的userInfo
        content.userInfo = ["index": number]
        
        // 设置categoryIdentifier
        content.categoryIdentifier = "other.category"
        
        
        // 设置attachments，用于推送GIF通知
        content.attachments = setGif()
        
        return content
    }
    
    
    
    
    
    
    // MARK: - 更新即将显示的通知
    @IBAction func renewNextNotification(_ sender: UIButton) {
        
        // 从通知中心获取所有未经展示的通知
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            
            // 取出通知中心里面未经展示通知列表中的第一个
            if let request = requests.first {
                
                // 如果该通知请求的标识符前缀为message.yourWifeRanAgain
                if request.identifier.hasPrefix("message.yourWifeRanAgain") {
                    
                    // 那么就修改通知的内容
                    self.updateNotification(request)
                    
                } else {
                    
                    // 如果该通知请求的标识符前缀不是message.yourWifeRanAgain，则执行拷贝
                    let content = request.content.mutableCopy() as! UNMutableNotificationContent
                    
                    // 创建通知请求，并且将其添加到通知中心
                    self.addNotification(request.identifier, content, request.trigger)
                }
            }
        }
    }
    
    /// 更新即将显示通知的内容
    func updateNotification(_ request: UNNotificationRequest) {
        
        // 获取所有标识符前缀为"message.yourWifeRanAgain"的请求
        if request.identifier.hasPrefix("message.yourWifeRanAgain") {
            
            // 根据userInfo中的键取出对应的值，并且将其强转成真实的类型
            var stepNumber = request.content.userInfo["index"] as! Int
            
            // 取余运算，能保证stepNumber的值永远都在有效的范围之内，可以防止数组越界
            stepNumber = (stepNumber + 1 ) % catchUp.count  // catchUp总共只有4个
            
            // 创建更新通知的内容
            let updatedContent = createNotificationContent()
            
            // 更新内容(根据stepNumber的值取数组catchUp中取出对应的值)
            updatedContent.body = catchUp[stepNumber]
            
            // 更新userInfo
            updatedContent.userInfo["index"] = stepNumber
            
            // 更新子标题
            updatedContent.subtitle = request.content.subtitle
            
            
            /** 更新图片通知 */
            updatedContent.attachments = setImages(stepNumber)
            
            // 创建通知请求，并且将其添加到通知中心
            addNotification(request.identifier, updatedContent, request.trigger)
        }
    }
    
    
    
    
    // MARK: - 查看等待通知
    @IBAction func viewPendingNotifications(_ sender: UIButton) {
        
        // 从通知中心获取所有还未展示的通知请求
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requestList) in
            
            // 查看当前还有多少个通知未展示
            print("\(Date()) -- 还有\(requestList.count)个通知请求未经展示。")
            
            // 遍历通知请求列表
            for request in requestList {
                print("未展示通知请求的标识符为: \(request.identifier), 内容为: \(request.content.body)")
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - 查看已发送通知
    @IBAction func viewDeliveredNotifications(_ sender: UIButton) {
        
        // 从通知中心获取已经展示过的通知
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            
            // 查看当前有多少个通知已经展示过了
            print("\(Date()) -- 已经展示了\(notifications.count)个通知。")
            
            // 遍历已经展示过的通知
            for notification in notifications {
                print("已展示通知请求的标识符为: \(notification.request.identifier), 内容为: \(notification.request.content.body)")
            }
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - 移除通知
    @IBAction func removeNotifications(_ sender: UIButton) {
        
        // 从通知中心获取所有还未展示的通知请求
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            if let request = requests.first {
                
                // 根据所给的标识符，移除所有与之对应的还未展示的通知
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
            
            // 一次性移除所有的通知
            // UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
}


// MARK: - 多媒体通知
extension ViewController {
    
    /// 加载音频或者视频资源
    func notificationAttachment(_ identifier: String, _ resource: String, _ type: String) -> [UNNotificationAttachment] {
        
        // 创建音频或视频通知的标识符
        let extendedIdentifier = identifier + "." + type  // send.video.mp4
        
        // 从Bundle中获取资源所在的路径
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            print("找不到文件\(resource).\(type)!")
            
            // 返回空的数组
            return []
        }
        
        // 将资源路径转化为URL地址
        let multimediaURL = URL(fileURLWithPath: path)
        
        // 进行错误处理(先尝试操作，如果失败了，则进行错误处理)
        do {
            
            // 先尝试根据标识符和资源URL创建attachement
            let attachement = try UNNotificationAttachment(identifier: extendedIdentifier, url: multimediaURL, options: [UNNotificationAttachmentOptionsThumbnailTimeKey: 10])
            
            // 返回创建成功的attachement
            return [attachement]
        }
        catch {
            print("attachement加载失败!")
            
            // 如果创建失败，则返回空的数组
            return []
        }
    }
    
    
    // 动图通知
    func setGif() -> [UNNotificationAttachment] {
        
        // 创建通知标识符
        let extendedIdentifier = "set.gif"
        
        // 从Bundle中获取资源所在的路径
        guard let path = Bundle.main.path(forResource: "动一动04", ofType: "gif") else {
            print("找不到文件!")
            
            // 返回空的数组
            return []
        }
        
        // 如果成功的加载到资源
        let gifURL = URL(fileURLWithPath: path)
        
        do {
            
            // 先尝试根据标识符和资源URL创建attachement(并且设置GIF的某一帧作为通知封面)
            let attachement = try UNNotificationAttachment(identifier: extendedIdentifier, url: gifURL, options: [UNNotificationAttachmentOptionsThumbnailTimeKey: 11])
            
            // 返回创建成功的attachement
            return [attachement]
        }
        catch {
            print("attachement加载失败!")
            
            // 创建失败则返回空的数组
            return []
        }
    }
    
    
    /// JPG图片通知
    func setImages(_ step: Int) -> [UNNotificationAttachment] {
        
        // 根据传递进来的步长创建字符串
        let stepString = String(format: "%i", step)
        
        // 设置每一条图片通知的标识符
        let identifier = "set.image." + stepString
        
        // 拼接图片的名称
        let resource = "跑了0" + stepString
        
        // 图片的扩展名
        let type = "jpg"
        
        // 调用notificationAttachment()函数并返回
        return notificationAttachment(identifier, resource, type)
    }
}








// MARK: - UNUserNotificationCenterDelegate
extension ViewController: UNUserNotificationCenterDelegate {
    
    // 实现代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // UNNotificationPresentationOptions的值有3个，但是前台通知不需要badge
        completionHandler([.alert, .sound])
    }
    
    
    // 用于实现可交互的通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 取出actionIdentifier
        let action = response.actionIdentifier
        
        // 取出发送请求
        let request = response.notification.request
        
        // 如果用户点击了"推送下一条"按钮
        if action == "next.action" {
            
            // 调用更新即将显示通知内容的方法，更新下一条内容
            updateNotification(request)
        }
        
        // 如果用户点击了"停止推送"按钮
        if action == "stop.action" {
            
            // 将带有该条标识符的通知从通知中心移除
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
        }
        
        // 如果用户点击了"稍后再推送"按钮
        if action == "sent.later.action" {
            
            // 创建触发器
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            
            // 重新创发送通知的请求
            let newRequest = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: trigger)
            
            // 将通知发送请求添加到发送中心
            UNUserNotificationCenter.current().add(newRequest, withCompletionHandler: { (error) in
                if error != nil {
                    // 如果有错误
                    print("\(String(describing: error?.localizedDescription))")
                }
            })
        }
        
        // 如果用户点击了"回复"按钮
        if action == "text.input" {
            
            // 将接收到的response内容转换成UNTextInputNotificationResponse
            let textResponse = response as! UNTextInputNotificationResponse
            
            // 创建通知内容
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            
            // 将回复的内容设置为newContent的子标题
            newContent.subtitle = textResponse.userText
            
            // 将回复的内容作为通知内容添加通知中心
            addNotification(request.identifier, newContent, request.trigger)
        }
        
        // 函数回调
        completionHandler()
    }
}

