//
//  File.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/8/30.
//
//

import Vapor

final class SignoutController:ResourceRepresentable {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func index(_ req:Request) throws -> ResponseRepresentable {
        //清空session中的user信息
        req.session?.data.removeKey("user")
        try? req.flash("success", msg: "退出成功")
        return Response(redirect: "signin")
    }
    
    func makeResource() -> Resource<String> {
        return Resource(
            index:index
        )
    }
}
