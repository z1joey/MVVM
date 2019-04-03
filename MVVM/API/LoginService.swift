//
//  LoginService.swift
//  MVVM
//
//  Created by Yi Zhang on 2019/4/4.
//  Copyright © 2019 Yi Zhang. All rights reserved.
//

import Foundation

class LoginService
{
    static func loginWithUsername(username: String, password: String, completion: @escaping (Bool)->Void) {
        if ("admin" == username && "password" == password) {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    static func generateAccessCode() -> String {
        return String.randomStr(len: 10)
    }
}

extension String{
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
}

