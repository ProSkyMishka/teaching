//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 29.01.2025.
//

import Foundation

struct UserDTO: Codable {
    let username: String
    let password: String
    let email: String
    let secretResponse: String
}
