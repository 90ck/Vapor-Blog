//
//  User.swift
//  vaporDemo
//
//  Created by ck on 2017/8/28.
//
//

import FluentProvider

final class User: Model {
    
    var name:String
    var password:String
    var avatar:String
    var gender:String
    var bio:String
    
    let storage: Storage = Storage()
    
    init(name:String,password:String,avatar:String,gender:String,bio:String) {
        self.name = name
        self.password = password
        self.avatar = avatar
        self.gender = gender
        self.bio = bio
    }
    
    init(row:Row) throws {
        self.name = try row.get("name")
        self.password = try row.get("password")
        self.avatar = try row.get("avatar")
        self.gender = try row.get("gender")
        self.bio = try row.get("bio")
    }
    
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("password", password)
        try row.set("avatar",avatar)
        try row.set("gender",gender)
        try row.set("bio",bio)
        return row
    }
    
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { users in
            users.id()
            users.string("name")
            users.string("password")
            users.string("gender")
            users.string("avatar")
            users.string("bio")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension User:JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("name", name)
        try json.set("password", password)
        try json.set("gender", gender)
        try json.set("avatar", avatar)
        try json.set("bio", bio)
        return json
    }
}



