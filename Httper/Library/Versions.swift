//
//  Versions.swift
//  Httper
//
//  Created by lidaye on 25/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

//MARK: - Versions string functionality
enum Semantic {
    case major, minor, patch, same, unknown
}

struct App {
    
    static var version: String = {
        guard
            let infoDictionary = Bundle.main.infoDictionary,
            let version = infoDictionary["CFBundleShortVersionString"] as? String
        else {
            return ""
        }
        return version
    }()
    
}
