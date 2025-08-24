//
//  Logger.swift
//  ott-demo
//
//  Created by Davis Zarins on 23/08/2025.
//

import Foundation
import os.log

final class Logger {
    private static let osLogger = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "app", category: "Analytics")
    
    static func log(_ type: OSLogType, _ message: String, file: String = #file, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(fileName):\(line)] \(message)"
        
        os_log("%{public}@", log: osLogger, type: type, logMessage)
    }
}
