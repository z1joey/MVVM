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
    private let codeRefreshTime = 5.0
    
    private var user = User() {
        didSet {
            username.value = user.username
        }
    }
    
    var username: Box<String> = Box("")
    
    var password: String {
        return user.password
    }
    
    var protectedUsername: String {
        if username.value.count >= minUsernameLength {
            var displayName = [Character]()
            for (index, character) in username.value.enumerated() {
                if index > username.value.count - minUsernameLength {
                    displayName.append(character)
                } else {
                    displayName.append("*")
                }
            }
            return String(displayName)
        }
        return username.value
    }
    
    var accessCode: Box<String?> = Box(nil)
    
    init(user: User = User()) {
        self.user = user
        startAccessCodeTimer()
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

private extension UserViewModel
{
    func startAccessCodeTimer() {
        accessCode.value = LoginService.generateAccessCode()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + codeRefreshTime) { [weak self] in
            self?.startAccessCodeTimer()
        }
    }
}
