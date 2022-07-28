//
//  CreateAction.swift
//  
//
//  Created by Łukasz Stachnik on 27/07/2022.
//

import FluentKit

struct CreateAction: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database
            .schema(Action.schema)
            .id()
            .field("name", .string, .required)
            .field("completed", .bool, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Action.schema).delete()
    }
}
