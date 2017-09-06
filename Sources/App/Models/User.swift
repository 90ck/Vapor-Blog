//
//  User.swift
//  vaporDemo
//
//  Created by ck on 2017/8/28.
//
//

import FluentProvider

final class User: Model,NodeConvertible,Timestampable {
    
    var name:String
    var password:String
    var avatar:String
    var gender:String
    var bio:String
    
    var posts:Children<User,Post> {
        return children()
    }
    
    let storage: Storage = Storage()
    
    init(name:String,password:String,avatar:String,gender:String,bio:String) {
        self.name = name
        self.password = password
        self.avatar = avatar
        self.gender = gender
        self.bio = bio
    }
    
    //row
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
    
    
    //node
    init(node:Node) throws {
        name = try node.get("name")
        password = try node.get("password")
        avatar = try node.get("avatar")
        gender = try node.get("gender")
        bio = try node.get("bio")
    }
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("name", name)
        try node.set("password", password)
        try node.set("avatar",avatar)
        try node.set("gender",gender)
        try node.set("bio",bio)
        try node.set("id", id)
        try node.set("created_at", createdAt)
        return node
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        
        try database.create(self) { users in
            users.id()
            users.string("name", length: nil ,optional: false ,unique: true)
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



extension User:JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get("name"), password: json.get("password"), avatar: json.get("avatar"), gender: json.get("gender"), bio: json.get("bio"))
    }
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



