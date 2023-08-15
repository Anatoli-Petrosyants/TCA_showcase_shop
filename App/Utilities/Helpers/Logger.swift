//
//  Logger.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.02.23.
//

import Foundation

#if !RELEASE
    // import Bugsee or any remote logger
#endif

struct Log {
    private static let debugLevelKey = "debug_level_enable"
    private static let infoLevelKey = "info_level_enable"
    private static let errorLevelKey = "error_level_enable"
    private static let networkInfoLevelKey = "network_info_level_enable"
    private static let memoryInfoLevelKey = "memory_info_level_enable"
    private static let purchaseInfoLevelKey = "purchase_info_level_enable"
    
    private static var isDebugEnable: Bool {
        return ProcessInfo.processInfo.environment[debugLevelKey] != nil
    }
    
    private static var isErrorEnable: Bool {
        return ProcessInfo.processInfo.environment[errorLevelKey] != nil
    }
    
    private static var isInfoEnable: Bool {
        return ProcessInfo.processInfo.environment[infoLevelKey] != nil
    }
    
    private static var isNetworkInfoEnable: Bool {
        return ProcessInfo.processInfo.environment[networkInfoLevelKey] != nil
    }
    
    private static var isMemoryInfoEnable: Bool {
        return ProcessInfo.processInfo.environment[memoryInfoLevelKey] != nil
    }
    
    private static var isPurchaseInfoLevelKey: Bool {
        return ProcessInfo.processInfo.environment[purchaseInfoLevelKey] != nil
    }
    
    static func initialize() {
        print("ℹ️[Configuration]: \(Configuration.current.buildConfiguration.rawValue.uppercased())")
    }
    
    static func network(_ item: Any?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let item = item else {
            return
        }
        let message = String(describing: item)
        
        if isNetworkInfoEnable == true {
            print("🌐[NETWORK]: \(message)")
        }
    }
        
    static func deinitOf(_ object: Any, file: String = #file, function: String = #function, line: UInt = #line) {
        let className = String(describing: type(of: object))

        if isMemoryInfoEnable == true {
            print("💀[MEMORY]: \(className) is deinit")
        }
    }
    
    static func initOf(_ object: Any, file: String = #file, function: String = #function, line: UInt = #line) {
        let className = String(describing: type(of: object))
    
        if isMemoryInfoEnable == true {
            print("🐣[MEMORY]: \(className) is initialized")
        }
    }
    
    static func purchase(_ logText: CustomStringConvertible?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let logText = logText else {
            return
        }
        
        if isPurchaseInfoLevelKey == true {
            print("💰[PURCHASE]: \(logText)")
        }
    }
    
    static func debug(_ logText: CustomStringConvertible?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let logText = logText else {
            return
        }
        let header = "******** \(function) ********"
        let footer = header.replaceAllChars(with: "*")

        if isDebugEnable == true {
            print("\n\(header)\n🔵[DEBUG]: \(logText) \n\(footer)\n")
        }
    }
    
    static func error(_ logText: CustomStringConvertible?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let logText = logText else {
            return
        }
        let header = "******** \(function) ********"
        let footer = header.replaceAllChars(with: "*")

        if isErrorEnable == true {
            print("\n\(header)\n🔴[ERROR]: \(logText) \n\(footer)\n")
        }
    }
    
    static func info(_ logText: CustomStringConvertible?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let logText = logText else {
            return
        }
        
        if isInfoEnable == true {
            print("ℹ️[INFO]: \(logText)")
        }
    }
    
    @discardableResult
    static func measure<A>(name: String = "", _ block: () -> A) -> A {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = block()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("⏱[TIME]: \(name) - \(timeElapsed)")
        return result
    }
}
