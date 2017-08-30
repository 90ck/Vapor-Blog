//
//  File.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/8/30.
//
//

import Vapor

final class SignoutController:ResourceRepresentable {
    
    func index(_ req:Request) throws -> ResponseRepresentable {
        //清空session中的user信息
        req.user = nil
        return Response(redirect: "/posts")
        
    }
    
    func makeResource() -> Resource<String> {
        return Resource(
            index:index
        )
    }
}
