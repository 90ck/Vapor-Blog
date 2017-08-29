import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// creating typical REST patterns
final class HelloController: ResourceRepresentable {
    let view: ViewRenderer
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    /// GET /hello
    func index(_ req: Request) throws -> ResponseRepresentable {
        let user = User.init(name: "asd", password: "12", avatar: "12", gender: "m", bio: "12")
        try user.save()
        print(user.id ?? "-null") // the newly saved pet's id
        return try view.make("hello", [
            "name": "World"
        ], for: req)
    }
    
    /// GET /hello/:string
    func show(_ req: Request, _ string: String) throws -> ResponseRepresentable {
        return try view.make("hello", [
            "name": string
        ], for: req)
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<String> {
        return Resource(
            index: index,
            show: show
        )
    }
}
