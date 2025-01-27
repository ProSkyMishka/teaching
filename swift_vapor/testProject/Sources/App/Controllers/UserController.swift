//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 27.01.2025.
//

import Fluent
import Vapor
import JWTKit

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("auth")
        
        users.post("signup", use: createUser)
    }
    
    @Sendable
    func createUser(req: Request) async throws -> UserDTO {
        let input = try req.content.decode(UserCreateDTO.self)
        
        guard try await User.query(on: req.db)
                .filter(\.$name == input.name)
                .first() == nil else {
            throw Abort(.badRequest, reason: "Username is already taken")
        }
        
        let newUser = User(name: input.name, email: input.email, password: input.password)
        try await newUser.save(on: req.db)
        return UserDTO(id: newUser.id, name: newUser.name, password: newUser.password, email: newUser.email, token: try await getToken(req: req, name: newUser.name, password: newUser.password))
    }
    
    
    
    func getToken(req: Request, name: String, password: String) async throws -> String {
        guard let user = try await User
            .query(on: req.db)
            .filter(\.$name == name)
            .first()
        else { throw Abort(.notFound) }
        
        if password != user.password {
            throw Abort(.unauthorized, reason: "Invalid username or password")
        }
        
        let payload = UserPayload(userID: try user.requireID())
        let token = try req.jwt.sign(payload)
        return token
    }
}

struct UserCreateDTO: Codable {
    let name: String
    let password: String
    let email: String
}


