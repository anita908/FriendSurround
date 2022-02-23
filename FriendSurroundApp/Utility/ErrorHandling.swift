//
//  ErrorHandling.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 2/17/22.
//

import Foundation

class HandlingErrors {
    static func show(_ errorCode: String) -> String {
        switch (errorCode) {
        case "Make sure that a valid username is passed for signUp":
            return "Plese enter a username";
        
        case "Make sure that a valid password is passed for signUp":
            return "Plese enter a password";
            
        case "Make sure that the password is valid":
            return "Password must contain a upper case letter, a lower case letter, a number and a special character";
            
        case "Make sure that the parameters passed are valid":
            return "Password must contain a upper case letter, a lower case letter, a number and a special character";
            
        case "Invoke the api with a different username":
            return "This username already exist";
            
        case "Check whether the given values are correct and the user is authorized to perform the operation.":
            return "Incorrect username or password";
            
          default:
            return "An error has occurred";
        }
   }
}
