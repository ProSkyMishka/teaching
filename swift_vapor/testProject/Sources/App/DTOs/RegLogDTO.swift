//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 27.01.2025.
//

import Foundation
import Fluent
import Vapor

struct RegLogDTO: Content {
    let id: Int
    let token: String
}
