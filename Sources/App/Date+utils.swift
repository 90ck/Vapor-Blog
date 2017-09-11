//
//  Date+utils.swift
//  vaporDemo
//
//  Created by 蔡可 on 2017/9/8.
//
//

import Foundation

extension Date {
    func formate(_ formate:String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = formate
        return formatter.string(from: self)
    }
}
