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
        
        let protected = users.grouped(JWTMiddleware())
        
        protected.get("data", use: getData)
        protected.get("users", use: getUsers)
        
        
    }
    
    @Sendable
    func createUser(req: Request) async throws -> RegLogDTO {
        let input = try req.content.decode(UserCreateDTO.self)
        
        guard try await User.query(on: req.db)
                .filter(\.$username == input.username)
                .first() == nil else {
            throw Abort(.badRequest, reason: "Username is already taken")
        }
        
        let newUser = User(name: input.username, email: input.email, password: input.password, response: input.secretResponse, token: "")
        newUser.reloadToken(token: try await getToken(req: req, user: newUser))
        try await newUser.save(on: req.db)
        return RegLogDTO(id: 1, token: newUser.token)
    }
    
    @Sendable
    func getUsers(req: Request) async throws -> [User] {
        let users = try await User.query(on: req.db).all()
        return users
    }
    
    @Sendable
    func getData(req: Request) async throws -> RegLogDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = try await User.find(payload.userID, on: req.db) else {
            throw Abort(.notFound)
        }
        return RegLogDTO(id: 0, token: user.token) // 200 Ok
    }
    
    
    func getToken(req: Request, user: User) async throws -> String {
        let payload = UserPayload(userID: try user.requireID())
        let token = try req.jwt.sign(payload)
        return token
    }
}

struct UserCreateDTO: Codable {
    let username: String
    let password: String
    let email: String
    let secretResponse: String
}

