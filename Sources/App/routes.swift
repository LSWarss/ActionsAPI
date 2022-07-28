import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("api", "actions") { req async throws -> Action in
        let action = try req.content.decode(Action.self)
        try await action.save(on: req.db)
        
        return action
    }
    
    app.get("api", "actions") { req async throws -> [Action] in
        try await Action.query(on: req.db).all()
    }
    
    app.get("api", "actions", ":actionID") { req async throws -> Action in
        guard let action = try await Action.find(req.parameters.get("actionID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return action
    }
    
    app.put("api", "actions", ":actionID") { req async throws -> Action in 
        let updatedAction = try req.content.decode(Action.self)
        guard let action = try await Action.find(req.parameters.get("actionID"), on: req.db)
        else {
            throw Abort(.notFound)
        }
        
        action.name = updatedAction.name
        try await action.save(on: req.db)
        return action
    }
    
    app.delete("api", "actions", ":actionID") { req async throws -> HTTPStatus in
        guard let action = try await Action.find(req.parameters.get("actionID"), on: req.db)
        else {
            throw Abort(.notFound)
        }
        
        try await action.delete(on: req.db)
        return .noContent
    }
    
    app.get("api", "actions", "search") { req async throws -> [Action] in
        guard let searchName = req.query[String.self, at: "name"] else {
            throw Abort(.badRequest)
        }
        
        return try await Action.query(on: req.db).group(.or) { or in
            or.filter(\.$name == searchName)
        }.all()
    }
}
