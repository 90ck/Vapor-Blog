@_exported import Vapor

extension Droplet {
    public func setup() throws {
        let routes = Routes(view)
        try collection(routes)
//        group(middleware: [CheckMiddleware()]) { (builder) in
//            /// 文章页
//            builder.resource("posts", PostsController(view))
//        }
    }
}
    
