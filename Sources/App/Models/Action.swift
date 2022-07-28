//
//  Action.swift
//  
//
//  Created by Łukasz Stachnik on 27/07/2022.
//

import Foundation
import Fluent
import Vapor

final class Action: Model {
    
    static let schema = "actions"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "completed")
    var completed: Bool
    
    init() {}
    
    init(id: UUID? = nil,
         name: String,
         completed: Bool = false) {
        self.id = id
        self.name = name
        self.completed = completed
    }
}

extension Action: Content {}
