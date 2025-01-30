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

import Vapor
import JWT

struct JWTMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let token = req.headers.bearerAuthorization?.token
        guard let token = token else {
            throw Abort(.unauthorized, reason: "Missing or invalid token")
        }

        req.auth.login(try req.jwt.verify(token, as: UserPayload.self))
        return try await next.respond(to: req)
    }
}

struct UserPayload: JWTPayload, Authenticatable {
    var userID: Int
    var exp: ExpirationClaim

    init(userID: Int) {
        self.userID = userID
        self.exp = .init(value: .distantFuture)
    }

    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
