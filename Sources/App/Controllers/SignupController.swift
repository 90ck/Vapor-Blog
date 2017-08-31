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
    init(_ view: ViewRenderer) {
        self.view = view
    }
    
    /// GET /signup
    func index(_ req: Request) throws -> ResponseRepresentable {
//        var a = Node.init([], in: nil)
        
        let res =  try view.make("signup",[req.flash])
        return res
        
    }
    
    func store(_ req: Request) throws -> ResponseRepresentable {
        
        let name = req.data["name"]?.string
        var password = req.data["password"]?.string
        let repassword = req.data["repassword"]?.string
        let gender = req.data["gender"]?.string
        let avatarBytes = req.data["avatar"]?.bytes
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
            if avatarBytes!.count <= 0{
                throw CheckError.msg("请选择上传头像")
            }
            
            let path = try Config().publicDir
            let avatar = "/images/\(Date().timeIntervalSince1970).png"
            try DataFile.write(avatarBytes!, to: path+avatar)
            
            //明文密码加密
            let pwBytes = try Hash.make(.sha1, password!.bytes)
            password = pwBytes.hexString
            
            let user = User.init(name: name!, password: password!, avatar: avatar, gender: gender!, bio: bio!)
            try user.save()
            
            try? req.assertSession().data.set("user", user)
            try? req.flash("success", msg: "注册成功")
        }
        catch CheckError.msg(let msg){
            try req.flash("error", msg: msg)
            return Response(redirect: "/signup")
        }
        catch let error as MySQLError where error.code == .dupEntry {
            //用户已存在
            try req.flash("success", msg: "用户已存在")
            return Response(redirect: "/signup")
        }
        catch {
            throw error
        }
        
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


//通知
extension Request {

    func flash(_ name:String,msg:String) throws {
        try session?.data.set("flash", [name:msg])
    }
    
    var flash:Node {
        get{
            let _flash:Node = (try? assertSession().data.get("flash")) ?? []
            session?.data.removeKey("flash")
            return _flash
        }
    }
}



