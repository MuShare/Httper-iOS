//
//  AppLog.swift
//  Httper
//
//  Created by Meng Li on 2019/02/07.
//  Copyright © 2019 MuShare. All rights reserved.
//

class AppLog {
    enum Level: Int {
        case debug = 0
        case info
        case warning
        case error
        case none
        
        var header: String {
            switch self {
            case .debug: return "R[D]"
            case .info: return "R[I]"
            case .warning: return "R[W]"
            case .error: return "R[E]"
            case .none: return ""
            }
        }
        
        var isEnabled: Bool {
            return self.rawValue >= AppLog.enabledLogLevel.rawValue
        }
    }
    
    static var enabledLogLevel: Level = .debug
    
    static func debug(_ message: String, tag: String = "", tags:[String] = []) {
        output(logLevel: .debug, tag: tag, tags: tags, message: message)
    }
    
    static func info(_ message: String, tag: String = "", tags:[String] = []) {
        output(logLevel: .info, tag: tag, tags: tags, message: message)
    }
    
    static func warning(_ message: String, tag: String = "", tags:[String] = []) {
        output(logLevel: .warning, tag: tag, tags: tags, message: message)
    }
    
    static func error(_ message: String, tag: String = "", tags:[String] = []) {
        output(logLevel: .error, tag: tag, tags: tags, message: message)
    }
    
    private static func createTagString(_ tag:String, _ tags: [String]) -> String {
        if !tag.isEmpty {
            return "[\(tag)] "
        }
        
        if tags.isEmpty {
            return " "
        } else {
            return "[" + tags.joined(separator: "][") + "] "
        }
    }
    
    private static func output(logLevel: Level, tag: String, tags:[String], message: String) {
        if !logLevel.isEnabled { return }
        #if DEBUG
        NSLog(logLevel.header + createTagString(tag, tags) + message)
        #endif
    }
}
