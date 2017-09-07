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
        
        var posts:[Post] = []
        let user = try req.assertSession().data["user"]
        if let author = req.data["author"]?.int {
            posts = try Post.makeQuery().filter("author", author).limit(10).all().map({ (post) -> Post in
                post.authorer = try post.owner.get()
                return post
            })
        }
        else {
            if user == nil {
                try req.flash("error", msg: "请先登录")
                return Response(redirect: "/signin")
            }
        }
        return try self.view.make("posts",[
            "blog":LeafData.blog,
            "posts":posts])
    }
    
    /// GET /posts/:id
    func show(_ req: Request, _ string: String) throws -> ResponseRepresentable {

        if string == "create" {
            return try postsCreate(req)
        }
        if let postid = string.int, postid != 0 {
            if let post = try Post.find(postid),let user = try post.owner.get() {
                return try self.view.make("post",[
                    "user":user,
                    "post":post,
                    "flash":req.flash,
                    "blog":LeafData.blog
                    ])
            }
            return Response(redirect: "create")
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

        if let user = try req.assertSession().data["user"] {
            return try self.view.make("create",["user":user,"flash":req.flash,"blog":LeafData.blog])
        }
        else{
            try req.flash("error", msg: "请先登录")
            return Response(redirect: "/signin")
        }
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

    static var blog:Node = ["title":"悟了个空","description":"这是一个swift服务端框架Vapor的webDemo"]
}



