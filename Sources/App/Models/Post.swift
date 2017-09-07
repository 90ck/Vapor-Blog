//
//  Post.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/9/1.
//
//

import FluentProvider

final class Post: Model,NodeConvertible,Timestampable {
    
    var author:Int
    var title:String
    var content:String
    var pv:Int
    
    
    
    var owner:Parent<Post,User> {
        return parent(id: Identifier(author))
    }
    
    var authorer:User?
    
    let storage: Storage = Storage()
    
    init(author:Int,title:String,content:String,pv:Int) {
        self.author = author
        self.title = title
        self.content = content
        self.pv = pv
    }
    
    func makeRow() throws -> Row {
        var row = Row.init()
        try row.set("author", author)
        try row.set("title", title)
        try row.set("content", content)
        try row.set("pv", pv)
        return row
    }
    
    init(row: Row) throws {
        self.author = try row.get("author")
        self.title = try row.get("title")
        self.content = try row.get("content")
        self.pv = try row.get("pv")
    }
    
    //node
    init(node:Node) throws {
        author = try node.get("author")
        title = try node.get("title")
        content = try node.get("content")
        pv = try node.get("pv")
        authorer = try node.get("authorer")
    }
    
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("author", author)
        try node.set("title", title)
        try node.set("content",content)
        try node.set("pv",pv)
        try node.set("id", id)
        try node.set("created_at", createdAt)
        try node.set("authorer", authorer)
        return node
    }
}

extension Post:Preparation {
    static func prepare(_ database: Database) throws {
        
        try database.create(self) { post in
            post.id()
            post.int("author")
            post.string("title")
            post.string("content")
            post.int("pv")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
