//
//  PostsController.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/8/31.
//
//
import Vapor

final class PostsController:ResourceMethod,ResourceRepresentable {
    let view:ViewRenderer
    init(_ view:ViewRenderer) {
        self.view = view
    }
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.assertSession().data["user"]
        
        return try self.view.make("posts",[["user":user],Local.shared])
    }
    
    func makeResource() -> Resource<String> {
        return Resource(
            index:index
        )
    }
}

struct Local {
    static var shared:Node = ["blog":["title":"ck的Blog","description":"这是我的vaporDemo"]]
    
    func abc()  {
        
    }
}



