//
//  CheckMiddleware.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/9/7.
//
//

import HTTP

final class CheckMiddleware:Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        if (try request.assertSession().data["user"]) == nil{
            try request.flash("error", msg: "请先登录")
            return Response(redirect: "/signin")
        }
        let response = try next.respond(to: request)
        print("checkLogin Middleware");
        return response
    }
}


final class LocalMiddleware:Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)
        print("local middleware");
        return response
    }
}
