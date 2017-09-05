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
    
    /// GET /posts
    func index(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.assertSession().data["user"]
        LeafData.shared["user"] = user
        return try self.view.make("posts",LeafData.shared)
    }
    
    /// GET /posts/:id
    func show(_ req: Request, _ string: String) throws -> ResponseRepresentable {
        if string == "create" {
            return try postsCreate(req)
        }
        else if let postid = string.int, postid != 0 {
            let post = try Post.find(postid)
            let user = post?.owner
            LeafData.shared["post"] = try post.makeNode(in: nil)
            LeafData.shared["user"] = try user.makeNode(in: nil)
            return try self.view.make("post",LeafData.shared)
        }
        throw Abort.notFound
    }
    
    
    
    /// POST /posts 发布一篇文章
    func store(_ req: Request) throws -> ResponseRepresentable {
        
        let author = try req.assertSession().data["user"]?["id"]?.int
        let title = req.data["title"]?.string
        let content = req.data["content"]?.string
        
        do {
            if title?.lengthOfBytes(using: .utf8) == 0 {
                throw CheckError.msg("请填写标题")
            }
            if content?.lengthOfBytes(using: .utf8) == 0 {
                throw CheckError.msg("请填写内容")
            }
            
            let post = Post.init(author: author!, title: title!, content: content!, pv: 0)
            try post.save()
            try req.flash("success", msg: "发布成功")
            return Response(redirect: "posts/\((post.id?.int)!)")
            
        } catch CheckError.msg(let msg) {
            try req.flash("error", msg: msg)
            return Response(redirect: "posts/create")
        }
        catch {
            throw error
        }
    }
    
    
    /// GET /posts/create
    func postsCreate(_ req: Request) throws -> ResponseRepresentable {
        
        let user = try req.assertSession().data["user"]
        LeafData.shared["user"] = user
        return try self.view.make("create",LeafData.shared)
    }
    
    
    
    
    func makeResource() -> Resource<String> {
        return Resource(
            index:index,
            store:store,
            show:show
        )
    }
}

struct LeafData {
    static var shared:Node = ["blog":["title":"悟了个空","description":"这是一个swift服务端框架Vapor的webDemo"]]
}



