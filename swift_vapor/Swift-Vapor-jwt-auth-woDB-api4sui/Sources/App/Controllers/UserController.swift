//
//  File.swift
//  
//
//  Created by Михаил Прозорский on 29.01.2025.
//

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
        let input = try req.content.decode(UserDTO.self)
        guard Vars.users.filter({$0.username == input.username}).first == nil
        else {
            throw Abort(.badRequest, reason: "Username is already taken")
        }
        let newUser = User(id: Vars.countID(), name: input.username, email: input.email, password: input.password, response: input.secretResponse, token: "")
        newUser.reloadToken(token: try await getToken(req: req, user: newUser))
        Vars.users.append(newUser)
        return RegLogDTO(id: 1, token: newUser.token)
    }
    
    @Sendable
    func getUsers(req: Request) async throws -> [User] {
        return Vars.users
    }
    
    @Sendable
    func getData(req: Request) async throws -> RegLogDTO {
        let payload = try req.auth.require(UserPayload.self)
        guard let user = Vars.users.filter({$0.id == payload.userID}).first else {
            throw Abort(.notFound)
        }
        return RegLogDTO(id: 0, token: user.token) // 200 Ok
    }
    
    
    func getToken(req: Request, user: User) async throws -> String {
        let payload = UserPayload(userID: user.id)
        let token = try req.jwt.sign(payload)
        return token
    }
}
