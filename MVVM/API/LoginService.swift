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
    class func loginWithUsername(username: String, password: String, completion: @escaping (Bool)->Void) {
        if ("admin" == username && "password" == password) {
            completion(true)
        } else {
            completion(false)
        }
    }
}
