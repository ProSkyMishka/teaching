import Fluent
import Vapor

func routes(_ app: Application) throws {
        app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: TodoController())
    
    let api = app.grouped("api") // Group under /api
        
    try api.register(collection: UserController())
}
