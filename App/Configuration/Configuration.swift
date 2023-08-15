//
//  Configuration.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.02.23.
//

// https://shockoe.com/blog/how-to-setup-configurations-and-schemes-in-xcode/
// https://benscheirman.com/2018/10/xcode-environment-specific-configuration/

import Foundation
import UIKit

public enum BuildConfiguration: String {
    case development
    case qa
    case release
}

protocol ShowcaseConfiguration {
    var buildConfiguration: BuildConfiguration { get }
    var baseURL: String { get }
    var appVersion: String { get }
    var client: String { get }
    var clientId: String { get }
    var buildNumber: Int { get }
    var operatingSystemVersion: OperatingSystemVersion { get }
    var osName: String { get }
    var deviceModel: String { get }
    var deviceName: String { get }
    var bundle: String { get }
    var executable: String { get }
    var systemLanguage: String { get }
    var deviceNotificationToken: String { get }
    var timezoneOffset: String { get }
    var apiVersion: String { get }
}

public class Configuration {
    
    // #dev Remove singlton when will start unittesting. A.P.
    public static let current = Configuration()
    
    private let config: NSDictionary
    
    let info: [String: Any] = { () -> [String: Any] in
        guard let info = Bundle.main.infoDictionary else {
            return [:]
        }
        return info
    }()
            
    init(dictionary: NSDictionary) {
        config = dictionary
    }
    
    private convenience init() {
        let bundle = Bundle.main
        let configPath = bundle.path(forResource: "config", ofType: "plist")!
        let config = NSDictionary(contentsOfFile: configPath)!
        
        let dict = NSMutableDictionary()
        
        if let commonConfig = config["Common"] as? [AnyHashable: Any] {
            dict.addEntries(from: commonConfig)
        }
        
        #if DEBUG
        if let developmentConfig = config["Development"] as? [AnyHashable: Any] {
            dict.addEntries(from: developmentConfig)
        }        
        #elseif QA
        if let qaConfig = config["QA"] as? [AnyHashable: Any] {
            dict.addEntries(from: qaConfig)
        }
        #elseif RELEASE
        if let releaseConfig = config["Release"] as? [AnyHashable: Any] {
            dict.addEntries(from: releaseConfig)
        }
        #endif
        
        self.init(dictionary: dict)
    }
}

extension Configuration: ShowcaseConfiguration {
    
    var buildConfiguration: BuildConfiguration {
        #if DEBUG
        return BuildConfiguration.development
        #elseif QA
        return BuildConfiguration.qa
        #elseif RELEASE
        return BuildConfiguration.release
        #endif
    }
    
    var baseURL : String {
        return config["base_url"] as! String
    }
    
    var appVersion: String {
        guard let appVersion = info["CFBundleShortVersionString"] else {
            return ""
        }
        return "\(appVersion)"
    }
    
    var client : String {
        return config["client"] as! String
    }
    
    var clientId: String {
        return config["clientId"] as! String
    }
    
    var buildNumber : Int {
        guard let bundleVersion = info["CFBundleVersion"]
            , let buildNumber = Int("\(bundleVersion)") else {
                return -1
        }
        
        return buildNumber
    }
    
    var operatingSystemVersion: OperatingSystemVersion {
        return ProcessInfo.processInfo.operatingSystemVersion
    }
    
    var osName : String {
        #if os(iOS)
        return "iOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(macOS)
        return "OS X"
        #elseif os(Linux)
        return "Linux"
        #else
        return "Unknown"
        #endif
    }
    
    var deviceModel: String {
        return UIDevice.current.model
    }
    
    var deviceName: String {
        return UIDevice.current.name
    }
    
    var bundle: String {
        guard let bundle = info[kCFBundleIdentifierKey as String] as? String else {
            return ""
        }
        return bundle
    }
    
    var executable: String {
        guard let executable = info[kCFBundleExecutableKey as String] as? String else {
            return ""
        }
        return executable
    }
    
    var systemLanguage: String {
        return Locale.current.language.languageCode?.identifier ?? "en"
    }
    
    var deviceNotificationToken: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    var timezoneOffset: String {
        return "\(-TimeZone.current.secondsFromGMT()/60)"
    }
    
    var apiVersion: String {
        return config["api_version"] as! String
    }    
}
