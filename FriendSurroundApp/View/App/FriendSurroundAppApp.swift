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
    }
    
    var body: some Scene {
        WindowGroup {
<<<<<<< HEAD
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
=======
//            MenuView().environmentObject(FriendViewModel())
            SetUpPhoneNumberView()
//            notification()
>>>>>>> origin/Anita05
        }
    }
}
