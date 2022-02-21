//
//  FriendSurroundAppApp.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/5/22.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct FriendSurroundAppApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    @ObservedObject var friendViewModel = FriendViewModel()
    
    init(){
        configureAmplify()
        sessionManager.getCurrentAuthUser()
        testLambda()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
            case .confirmCode(let username, let email):
                ConfirmationView(username: username, email: email)
                    .environmentObject(sessionManager)
            case .session(let user):
                MenuView(user: user)
                    .environmentObject(sessionManager)
                    .environmentObject(friendViewModel)
            }
        }
    }
    
    func configureAmplify() {
        do {
            // Authentication
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            
            try Amplify.configure()
            
            print("Configured Amplify Successfully!")
        } catch {
            print("Failed to configure Amplify 😢")
            sessionManager.authState = .signUp
        }
    }
    
    func testLambda() {
        let message = #"{"message": "running test"}"#
        let request = RESTRequest(path: "/test", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
            case .failure(let apiError):
                print("Failed", apiError)
            }
        }
    }
}
