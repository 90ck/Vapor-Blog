//
//  SigninController.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/8/31.
//
//


import Vapor
import Crypto
final class SigninController:ResourceRepresentable,ResourceMethod {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    ///GET /signin
    func index(_ req:Request) throws -> ResponseRepresentable {
        
        return try self.view.make("signin",["flash":req.flash,"blog":LeafData.blog])
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        let name = req.data["name"]?.string
        let password = req.data["password"]?.string
        guard let user = try User.makeQuery().filter("name", name).first() else {
            try req.flash("error", msg: "用户不存在")
            return Response(redirect: "/signin")
        }
        //明文密码加密
        let pw = try Hash.make(.sha1, password!.bytes).hexString
        if pw != user.password {
            try req.flash("error", msg: "用户名或密码错误")
            return Response(redirect: "/signin")
        }
        try req.flash("success", msg: "登录成功")
        try req.assertSession().data.set("user", user)
        
        return Response(redirect: "/posts?author=\((user.id?.int)!)")
    }
    
    
    func makeResource() -> Resource<String> {
        return Resource(
            index:index,
            store:store
        )
    }
}





