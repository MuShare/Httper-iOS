//
//  Versions.swift
//  Httper
//
//  Created by lidaye on 25/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation

//MARK: - Versions string functionality
public enum Semantic {
    case major, minor, patch, same, unknown
}

public struct App {
    
    public static var version: String = {
        var version: String = ""
        if let infoDictionary = Bundle.main.infoDictionary {
            version = infoDictionary["CFBundleShortVersionString"] as! String
        }
        return version
    }()
}


public extension String {
    
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    
    public subscript (r: Range<Int>) -> String {
        return substring(with: characters.index(startIndex, offsetBy: r.lowerBound)..<characters.index(startIndex, offsetBy: r.upperBound))
    }
    
    
    public var major: String {
        return self[0]
    }
    
    
    public var minor: String {
        return self[Range(0...2)]
    }
    
    
    public var patch: String {
        return self[Range(0...4)]
    }
    
    
    public func newerThan(_ version :String) -> Bool {
        return self.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    
    public func olderThan(_ version: String) -> Bool {
        let isEqual: Bool = self == version
        return !isEqual ? !self.newerThan(version) : false
    }
    
    
    public func majorChange(_ version: String) -> Bool {
        return self.major != version.major
    }
    
    
    public func minorChange(_ version: String) -> Bool {
        return self.minor != version.minor && self.olderThan(version)
    }
    
    
    public func patchChange(_ version: String) -> Bool {
        return self.patch != version.patch && self.olderThan(version)
    }
    
    
    public func semanticCompare(_ version: String) -> Semantic {
        switch self {
        case _ where self == version:
            return .same
        case _ where self.major != version.major:
            return .major
        case _ where self.minor != version.minor && self.olderThan(version):
            return .minor
        case _ where self.patch != version.patch && self.olderThan(version):
            return .patch
        default:
            return .unknown
        }
    }
    
}
