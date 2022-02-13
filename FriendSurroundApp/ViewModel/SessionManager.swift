//
//  SessionManager.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/5/22.
//

import Foundation
import Amplify

enum AuthState {
    case signUp
    case login
    case confirmCode(username: String, email: String)
    case session(user: AuthUser)
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    
    @Published var errorMessage: String = ""
    //What state is the user in?
    func getCurrentAuthUser(){
        print("checking for user...")
        //If we get a user, then we know they are logged in
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .session(user: user)
        }
        //otherwise send them to login page
        else {
            authState = .login
        }
    }
    
    func showSignUp(){
        authState = .signUp
    }
    
    func showLogin(){
        authState = .login
    }
    
    func signUp(username: String, phoneNumber: String, email: String, password: String, firstname: String, lastname: String){
        let attributes = [AuthUserAttribute(.email, value: email),AuthUserAttribute(.phoneNumber, value: phoneNumber), AuthUserAttribute(.givenName, value: firstname), AuthUserAttribute(.familyName, value: lastname)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options) { [weak self] result in
                
                switch result {
                case .success(let signUpResult):
                    print("Sign up result", signUpResult)
                    
                    switch signUpResult.nextStep {
                    case .done:
                        print("Finished Sign Up")
                        self?.showLogin()
                    case .confirmUser(let details, _):
                        print(details ?? "no details")
                        
                        DispatchQueue.main.async {
                            self?.authState = .confirmCode(username: username, email: email)
                        }
                    }
                case .failure(let error):
                    print("Sign up error", error)
                    self?.errorMessage = error.debugDescription
                }
                
            }
    }
    
    func confirm(username: String, code: String){
        _ = Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: code
        ){ [weak self] result in
            
            switch result{
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete{
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
                
            case .failure(let error):
                print("failed to confirm code", error)
            }
        }
    }
    
    func login(username: String, password: String){
        _ = Amplify.Auth.signIn(
            username: username,
            password: password
        ){  [weak self] result in
            
            switch result{
                
            case .success(let signInResult):
                print(signInResult)
                if signInResult.isSignedIn{
                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                    }
                }
                
            case .failure(let error):
                print("Login error:", error)
            }
                
        }
    }
    
    func signOut(){
        _ = Amplify.Auth.signOut
        { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
            case .failure(let error):
                print("Sign out error", error)
            }
            
        }
    }
}
