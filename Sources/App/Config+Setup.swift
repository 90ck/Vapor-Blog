import LeafProvider
import MySQLProvider
extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [JSON.self, Node.self]
        
        try setupProviders()
        setupPreparation()
        addMiddleware()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(LeafProvider.Provider.self)
        try addProvider(MySQLProvider.Provider.self)
//        try addProvider(LocalProvider.self)
    }
    
    private func setupPreparation() {
        preparations.append(User.self)
        preparations.append(Post.self)
    }
    
    private func addMiddleware() {
        addConfigurable(middleware: CheckMiddleware(), name: "checkLogin")

//        addConfigurable(middleware: LocalMiddleware(), name: "local")
        
    }
}
