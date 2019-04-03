//
//  UserViewModel.swift
//  MVVM
//
//  Created by Yi Zhang on 2019/4/4.
//  Copyright © 2019 Yi Zhang. All rights reserved.
//

import Foundation

enum UserValidationState {
    case Valid
    case Invalid(String)
}

class UserViewModel
{
    private let minUsernameLength = 4
    private let minPasswordLength = 5
    private var user = User()
    
    var username: String {
        return user.username
    }
    
    var password: String {
        return user.password
    }
    
    var protectedUsername: String {
        if username.count >= minUsernameLength {
            var displayName = [Character]()
            for (index, character) in username.enumerated() {
                if index > username.count - minUsernameLength {
                    displayName.append(character)
                } else {
                    displayName.append("*")
                }
            }
            return String(displayName)
        }
        return username
    }
}

extension UserViewModel
{
    func updateUsername(username: String) {
        user.username = username
    }
    
    func updatePassword(password: String) {
        user.password = password
    }
    
    func validate() -> UserValidationState {
        if user.username.isEmpty || user.password.isEmpty {
            return .Invalid("Username and password are required.")
        }
        
        if user.username.count < minUsernameLength {
            return .Invalid("Username needs to be at least \(minUsernameLength) characters")
        }
        
        if user.password.count < minPasswordLength {
            return .Invalid("Password needs to be at least \(minPasswordLength) characters")
        }
        
        return .Valid
    }
    
    // login是否在ViewModel有争议
    func login(completion:@escaping (String?) -> Void) {
        LoginService.loginWithUsername(username: user.username, password: user.password) { success in
            if success {
                completion(nil)
            } else {
                completion("Invalid")
            }
        }
    }
}
