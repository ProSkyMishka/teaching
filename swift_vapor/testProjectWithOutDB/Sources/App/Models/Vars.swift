//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 29.01.2025.
//

import Foundation

class Vars {
    private static var counterID = -1
    static var users: [User] = []
    
    static func countID() -> Int {
        self.counterID += 1
        return self.counterID
    }
}
