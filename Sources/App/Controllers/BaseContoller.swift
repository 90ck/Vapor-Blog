//
//  BaseContoller.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/8/31.
//
//

import Vapor

protocol ResourceMethod {

    /// GET /xxx
    func index(_ req: Request) throws -> ResponseRepresentable
    
    /// GET /xxx/:string
    func show(_ req: Request, _ string: String) throws -> ResponseRepresentable
    
    /// POST /xxx
    func store(_ req:Request) throws -> ResponseRepresentable
    
}


extension ResourceMethod {
    
    func index(_ req: Request) throws -> ResponseRepresentable {
        return "没有实现\(#function)"
    }
    
    func show(_ req: Request, _ string: String) throws -> ResponseRepresentable {
        return "没有实现\(#function)"
    }
    
    func store(_ req:Request) throws -> ResponseRepresentable {
        return "没有实现\(#function)"
    }
    
}


class BaseController: ResourceMethod {
    var view: ViewRenderer
    
    init(_ view: ViewRenderer) {
        self.view = view
    }
}

