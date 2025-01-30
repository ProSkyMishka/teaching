//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 29.01.2025.
//

//
//  File.swift
//
//
//  Created by Михаил Прозорский on 27.01.2025.
//

import struct Foundation.UUID
import Vapor

final class User: Sendable, Content {
    var id: Int
    var username: String
    var email: String
    var password: String
    var secretResponse: String
    var token: String

    init(id: Int, name: String, email: String, password: String, response: String, token: String) {
        self.id = id
        self.username = name
        self.email = email
        self.password = password
        self.secretResponse = response
        self.token = token
    }
    
    func reloadToken(token: String) {
        self.token = token
    }
}

