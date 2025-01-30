//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 27.01.2025.
//

import Fluent
import struct Foundation.UUID
import Vapor

final class User: Model, Sendable, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String
    @Field(key: "email")
    var email: String
    @Field(key: "password")
    var password: String
    @Field(key: "secretResponse")
    var secretResponse: String
    @Field(key: "token")
    var token: String
    
    

    init() { }

    init(id: UUID? = nil, name: String, email: String, password: String, response: String, token: String) {
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

