//
//  EventTracker.swift
//  DesktopNote
//
//  Created by cswenshuo on 2024/12/28.
//  Copyright © 2024 cswenshuo. All rights reserved.
//

import Foundation
import Combine

class EventTracker {
    static let shared = EventTracker()
    private var serverURL: URL {
        #if DEBUG
        return URL(string: "http://localhost:3000/api/event")!
        #else
        return URL(string: "https://event-track-lbxwirpgsx.ap-northeast-1.fcapp.run/api/event")!
        #endif
    }
    
    private init() {}
    
    /// 埋点数据结构
    struct Event: Codable {
        let key: String
        let deviceID: String
        let timestamp: TimeInterval
        let appVersion: String
        let appID: String
        let userLocation: String
        let userLanguage: String
        let extra: [String: AnyCodable] // 用 AnyCodable 来支持任意类型
    }
    
    /// 上传埋点
    /// - Parameters:
    ///   - key: 埋点 key
    ///   - extra: 额外信息
    func trackEvent(key: String, extra: [String: Any] = [:]) {
        print("Track event: \(key)")
        let event = Event(
            key: key,
            deviceID: getDeviceID(),
            timestamp: Date().timeIntervalSince1970 * 1000,
            appVersion: getAppVersion(),
            appID: getAppID(),
            userLocation: getUserLocation(),
            userLanguage: getUserLanguage(),
            extra: extra.mapValues { AnyCodable($0) }
        )
        
        uploadEvent(event)
    }
    
    /// 上传到服务器
    private func uploadEvent(_ event: Event) {
        var request = URLRequest(url: serverURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(event)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode event: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to upload event: \(error)")
                return
            }
            print("Event uploaded successfully")
        }
        task.resume()
    }
    
    // MARK: - Helpers
    
    func getDeviceID() -> String {
        let key = "CustomDeviceID"
        if let deviceID = UserDefaults.standard.string(forKey: key) {
            return deviceID
        } else {
            let newDeviceID = UUID().uuidString
            UserDefaults.standard.set(newDeviceID, forKey: key)
            return newDeviceID
        }
    }
    
    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    private func getAppID() -> String {
        return Bundle.main.bundleIdentifier ?? "Unknown"
    }
    
    private func getUserLocation() -> String {
        return Locale.current.regionCode ?? "Unknown"
    }
    
    private func getUserLanguage() -> String {
        return Locale.current.languageCode ?? "Unknown"
    }
}

/// AnyCodable 支持
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = value as? String {
            try container.encode(value)
        } else if let value = value as? Int {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? [AnyCodable] {
            try container.encode(value)
        } else if let value = value as? [String: AnyCodable] {
            try container.encode(value)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported type"))
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self.value = value
        } else if let value = try? container.decode(Int.self) {
            self.value = value
        } else if let value = try? container.decode(Double.self) {
            self.value = value
        } else if let value = try? container.decode(Bool.self) {
            self.value = value
        } else if let value = try? container.decode([AnyCodable].self) {
            self.value = value
        } else if let value = try? container.decode([String: AnyCodable].self) {
            self.value = value
        } else {
            throw DecodingError.typeMismatch(AnyCodable.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported type"))
        }
    }
}

enum EventKey: String {
    case subscripionButtonClick = "subscription_button_click"
    case subscripionViewShow = "subscripion_view_show"
    case subscripionViewPriceShow = "subscripion_view_price_show"
    case subscripionSuccess = "subscripion_success"
    case subscripionFail = "subscripion_fail"
    case appUse = "app_use"
    case subscriptionViewPriceFail = "subscripion_view_price_fail"

    // 添加更多埋点 Key ...
}
