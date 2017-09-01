//
//  File.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/8/31.
//
//
import Vapor
final class LocalProvider: Vapor.Provider {
    
    static var repositoryName: String = "Local-Provider"
    
    static var local:Node? = []
    
    required init(config: Config) throws {
        
        guard let local = config["local"]?.object else {
            throw ConfigError.missingFile("local")
        }
        LocalProvider.local = try local.makeNode(in: nil)
    }
    func boot(_ config: Config) throws { }
    
    func boot(_ droplet: Droplet) throws { }
    
    func beforeRun(_ droplet: Droplet) throws {
        droplet.console.info(LocalProvider.local.debugDescription)
    }
}
