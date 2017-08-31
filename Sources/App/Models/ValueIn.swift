//
//  ValueIn.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/8/31.
//
//

import Leaf

class ValueIn: BasicTag {
    
    let name = "valueIn"
    
    func run(arguments: ArgumentList) throws -> Node? {
        guard
            arguments.count == 2,
            let key = arguments[1]?.string,
            let dic = arguments[0]
            else { return nil }
        return try dic.get(key)
    }
}
