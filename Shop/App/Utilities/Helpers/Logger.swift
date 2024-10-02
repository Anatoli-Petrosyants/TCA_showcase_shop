//
//  Logger.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 27.02.23.
//

import Foundation
import OSLog

// let logegr = Logger(subsystem: <#T##String#>, category: <#T##String#>)

#if !RELEASE
    // Import Bugsee or any other remote logger for debugging in non-release mode.
#endif

// A utility struct for custom logging with different log levels and features.
struct Log {
    // Keys for environment variables indicating different log levels.
    private static let debugLevelKey = "debug_level_enable"
    private static let infoLevelKey = "info_level_enable"
    private static let errorLevelKey = "error_level_enable"
    private static let networkInfoLevelKey = "network_info_level_enable"
    private static let memoryInfoLevelKey = "memory_info_level_enable"
    private static let purchaseInfoLevelKey = "purchase_info_level_enable"

    // Check if debug logging is enabled.
    private static var isDebugEnable: Bool {
        return ProcessInfo.processInfo.environment[debugLevelKey] != nil
    }

    // Check if error logging is enabled.
    private static var isErrorEnable: Bool {
        return ProcessInfo.processInfo.environment[errorLevelKey] != nil
    }

    // Check if info logging is enabled.
    private static var isInfoEnable: Bool {
        return ProcessInfo.processInfo.environment[infoLevelKey] != nil
    }

    // Check if network info logging is enabled.
    private static var isNetworkInfoEnable: Bool {
        return ProcessInfo.processInfo.environment[networkInfoLevelKey] != nil
    }

    // Check if memory info logging is enabled.
    private static var isMemoryInfoEnable: Bool {
        return ProcessInfo.processInfo.environment[memoryInfoLevelKey] != nil
    }

    // Check if purchase info logging is enabled.
    private static var isPurchaseInfoLevelKey: Bool {
        return ProcessInfo.processInfo.environment[purchaseInfoLevelKey] != nil
    }

    // Initialize the logging utility.
    static func initialize() {
        print("ℹ️[Configuration]: \(Configuration.current.buildConfiguration.rawValue.uppercased())")
    }

    // Log network-related information.
    static func network(_ item: Any?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let item = item else {
            return
        }
        let message = String(describing: item)

        if isNetworkInfoEnable == true {
            print("🌐[NETWORK]: \(message)")
        }
    }

    // Log object deallocation.
    static func deinitOf(_ object: Any, file: String = #file, function: String = #function, line: UInt = #line) {
        let className = String(describing: type(of: object))

        if isMemoryInfoEnable == true {
            print("💀[MEMORY]: \(className) is deinit")
        }
    }

    // Log object initialization.
    static func initOf(_ object: Any, file: String = #file, function: String = #function, line: UInt = #line) {
        let className = String(describing: type(of: object))

        if isMemoryInfoEnable == true {
            print("🐣[MEMORY]: \(className) is initialized")
        }
    }

    // Log purchase-related information.
    static func purchase(_ logText: CustomStringConvertible?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let logText = logText else {
            return
        }

        if isPurchaseInfoLevelKey == true {
            print("💰[PURCHASE]: \(logText)")
        }
    }

    // Log debug information.
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

    // Log error information.
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

    // Log info information.
    static func info(_ logText: CustomStringConvertible?, file: String = #file, function: String = #function, line: UInt = #line) {
        guard let logText = logText else {
            return
        }

        if isInfoEnable == true {
            print("ℹ️[INFO]: \(logText)")
        }
    }

    // Measure and log the time taken by a block of code.
    @discardableResult
    static func measure<A>(name: String = "", _ block: () -> A) -> A {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = block()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("⏱[TIME]: \(name) - \(timeElapsed)")
        return result
    }
}

