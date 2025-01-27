//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 27.01.2025.
//

import Foundation
import Fluent
import Vapor

struct UserDTO: Content {
    let id: UUID?
    let name: String
    let password: String
    let email: String
    let token: String
}
