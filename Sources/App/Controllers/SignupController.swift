//
//  SignupController.swift
//  vaporDemo
//
//  Created by ck on 2017/8/28.
//
//
//
import Vapor
import HTTP
import Crypto
import MySQL

enum CheckError:Error {
    case msg(_:String)
}

final class SignupController: ResourceRepresentable {
    let view: ViewRenderer
    var notification:Node?
    
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    /// GET /signup
    func index(_ req: Request) throws -> ResponseRepresentable {
        let res =  try view.make("signup",notification)
        notification = nil
        return res
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        
        let name = req.data["name"]?.string
        var password = req.data["password"]?.string
        let repassword = req.data["repassword"]?.string
        let gender = req.data["gender"]?.string
        let avatar = req.data["avatar"]?.string
        let bio = req.data["bio"]?.string
        
        do {
            if name!.lengthOfBytes(using: .utf8) < 1 || name!.lengthOfBytes(using: .utf8) > 10{
                throw CheckError.msg("名字请限制在 1-10 个字符")
            }
            if (password?.lengthOfBytes(using: .utf8))! < 6 {
                throw CheckError.msg("密码至少 6 个字符")
            }
            if password != repassword {
                throw CheckError.msg("两次密码输入不一致")
            }
            if !["m","f","x"].contains(gender!){
                throw CheckError.msg("性别只能是 m、f 或 x")
            }
//            if avatar!.lengthOfBytes(using: .utf8) <= 0{
//                throw CheckError.msg("名字请限制在 1-10 个字符")
//            }
        }
        catch CheckError.msg(let msg){
            notification = ["error":msg.makeNode(in: nil)]
            return Response(redirect: "/signup")
        }
        
        //明文密码加密
        let pwBytes = try Hash.make(.sha1, password!.bytes)
        password = pwBytes.hexString
        
        let user = User.init(name: name!, password: password!, avatar: avatar!, gender: gender!, bio: bio!)
        do {
            try user.save()
        } catch MySQLError.Code.dupEntry {
            //用户已存在
            notification = ["error":"用户名已存在"]
            return Response(redirect: "/signup")
        }
        req.user = user
        notification = ["success":"注册成功"]
        return Response(redirect: "/posts")
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<String> {
        return Resource(
            index: index,
            store:store
        )
    }
}
extension Request {

    func flash(name:String?,msg:String?) {
        storage[name!] = msg
    }
    
//    func set(_ key:String, value:Any?) throws {
//        try session?.data.set(key, value)
//    }
//    
//    func get(_ key:String) throws -> Any{
//        return try User(node: session?.data[key])
//    }
//    
    var user:User? {
        get{
            do {
                return try User(node: session?.data["user"])
            } catch {
                return nil
            }
        }
        set{
            do {
                try session?.data.set("user", newValue)
            } catch {
                
            }
        }
    }
}



