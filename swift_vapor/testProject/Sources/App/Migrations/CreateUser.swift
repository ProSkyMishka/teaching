//
//  CreateUser.swift
//
//
//  Created by Михаил Прозорский on 21.11.2024.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: Database) async throws {
        try await db.schema(User.schema)
            .id()
            .field("name", .string, .required)
            .field("password", .string, .required)
            .field("email", .string, .required)
            .create()
    }
    
    func revert(on db: Database) async throws {
        try await db.schema(User.schema).delete()
    }
}
