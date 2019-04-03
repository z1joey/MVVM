//
//  LoginViewController.swift
//  MVVM
//
//  Created by Yi Zhang on 2019/4/4.
//  Copyright © 2019 Yi Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private var viewModel = UserViewModel()
    
    var loginSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension LoginViewController
{
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func authenticate() {
        dismissKeyboard()

        switch viewModel.validate() {
        case .Valid:
            viewModel.login { (errorMessage) in
                if let errorMessage = errorMessage {
                    self.displayErrorMessage(errorMessage: errorMessage)
                } else {
                    self.loginSuccess?()
                }
            }
        case .Invalid(let error):
            displayErrorMessage(errorMessage: error)
        }
    }
}

// MARK: TextField Delegate
extension LoginViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameField {
            textField.text = viewModel.username
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameField {
            textField.text = viewModel.protectedUsername
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else {
            authenticate()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == usernameField {
            viewModel.updateUsername(username: newString)
        } else if textField == passwordField {
            viewModel.updatePassword(password: newString)
        }
        
        return true
    }
}

// MARK: Private Methods
private extension LoginViewController
{
    func displayErrorMessage(errorMessage: String) {
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
