import Vapor

final class Routes: RouteCollection {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    func build(_ builder: RouteBuilder) throws {
        /// GET /
        builder.get { req in
            return try self.view.make("welcome")
        }
        
        /// GET /hello/...
        builder.resource("hello", HelloController(view))
        
        /// 注册页
        builder.resource("signup", SignupController(view))
        
        /// 登录
        builder.resource("signin", SigninController(view))
        
        /// 登出
        builder.resource("signout", SignoutController(view))
        
        /// 文章页
        builder.resource("posts", PostsController(view))

        
        
        // response to requests to /info domain
        // with a description of the request
        builder.get("info") { req in
            return req.description
        }
        
    }
}
