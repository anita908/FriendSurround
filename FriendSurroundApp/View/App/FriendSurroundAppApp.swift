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
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
            case .signUp:
                SetUpNameView()
                    .environmentObject(sessionManager)
//            case .confirmCode(let username):
//                ConfirmationView()
            case .session(let user):
                MenuView(user: user)
                    .environmentObject(sessionManager)
            default:
                LoginView()
                    .environmentObject(sessionManager)
                    .environmentObject(friendViewModel)
            
            }
//            MenuView()
//                .environmentObject(FriendViewModel())
        }
    }
    
    func configureAmplify() {
        do {
            // Authentication
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            
            try Amplify.configure()
            
            print("Configured Amplify Successfully!")
        } catch {
            print("Failed to configure Amplify 😢")
        }
    }
}
