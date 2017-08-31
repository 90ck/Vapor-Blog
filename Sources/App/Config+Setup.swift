import LeafProvider
import MySQLProvider
extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [JSON.self, Node.self]
        
        try setupProviders()
        setupPreparation()
 
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(LeafProvider.Provider.self)
        try addProvider(MySQLProvider.Provider.self)
        try addProvider(LocalProvider.self)
    }
    
    private func setupPreparation() {
        preparations.append(User.self)
        
    }
}
