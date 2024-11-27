//
//  RateMeHelper.swift
//  DesktopNote
//
//  Created by cswenshuo on 2023/11/7.
//  Copyright © 2023 cswenshuo. All rights reserved.
//
import Cocoa
import SwiftUI
import Foundation
import Defaults

class RateSubscribeHelper {
  static let shared = RateSubscribeHelper()
  var premiumWindow : NSWindow!
  var reviewWindow: NSWindow!
  var rateMeInterval : Double = 12*60*60
  var reminderType: ReminderType = .subscribe
  var expiresDate = Date(timeIntervalSince1970: 0)

  func check(reminderType: ReminderType? = nil){
    if let reminderType = reminderType {
        self.reminderType = reminderType
    }
    
    guard Date() > expiresDate else { return }
        
    switch self.reminderType {
    case .subscribe:
        if Store.shared.recipe?.isLocked == true {
          rateMeInterval = 12*60*60
          openPremiumWindow()
          expiresDate = Date().addingTimeInterval(rateMeInterval)
        }else{
          //对于付费用户，减少点评打扰
          rateMeInterval = 48*60*60
        }
        self.reminderType = .review
    default:
        if !Defaults[.hasRate] {
          openReviewWindow()
          expiresDate = Date().addingTimeInterval(rateMeInterval)
        }
        self.reminderType = .subscribe
    }
  }
  func hasRate(){
      UserDefaults.standard.setValue(true, forKey: "hasRate")
  }
  func openPremiumWindow() {
      //每次打开设置页面重新获取商品&重新检查订阅状态
      Store.shared.fetchProduct()
      if nil == premiumWindow {
          let premiumView = PremiumView()
          premiumWindow = NSWindow(
              contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
              styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
              backing: .buffered,
              defer: false)
          premiumWindow.titlebarAppearsTransparent = true
          premiumWindow.center()
          premiumWindow.setFrameAutosaveName("Premium")
          premiumWindow.isReleasedWhenClosed = false
          premiumWindow.contentView = NSHostingView(rootView: premiumView)
      }
      NSApp.activate(ignoringOtherApps: true)
      premiumWindow.makeKeyAndOrderFront(nil)
  }
  func openReviewWindow(){
    let contentView = ReviewView()
    reviewWindow = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 880, height: 700),
        styleMask: [.titled, .closable, .fullSizeContentView],
        backing: .buffered, defer: false)
    reviewWindow.center()
      //使得窗口关闭后可以重新通过dock打开
    reviewWindow.titlebarAppearsTransparent = true
    reviewWindow.backgroundColor = NSColor(named: "RateUs")!
    reviewWindow.titleVisibility = .hidden
    reviewWindow.isReleasedWhenClosed = false
    reviewWindow.setFrameAutosaveName("Like Window")
    reviewWindow.contentView = NSHostingView(rootView: contentView)
    NSApp.activate(ignoringOtherApps: true)
    reviewWindow.makeKeyAndOrderFront(nil)
  }
  
  func closeReviewWindow(){
      reviewWindow.close()
  }
  
  func closePremiumWindow(){
      premiumWindow.close()
  }

}

enum ReminderType {
    case review
    case subscribe
}
