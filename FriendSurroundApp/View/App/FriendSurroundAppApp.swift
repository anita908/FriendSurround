//
//  FriendSurroundAppApp.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/5/22.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import zlib

@main
struct FriendSurroundAppApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    @ObservedObject var friendViewModel = FriendViewModel()
    
    init(){
        configureAmplify()
        sessionManager.getCurrentAuthUser()
        initializeUserData()
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

    func initializeUserData() {
        let message = #"{"username": "nesdom13", "newLocation": "10,4"}"#
        let request = RESTRequest(path: "/location", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
                
                //Here's an example of how we can parse the data into a json format and work with the attributes how we'd like.
                // make sure the JSON is in the format we expect
                if let json = data.toJSON() {
                    if let userData = json["userData"] as? [String:Any] {
                        if let friends = userData["friends"] as? [[String:Any]] {
                            for friend in friends {
                                
                                print(friend["username"] as? String ?? "")
                            }
                        }
                        else {
                            print("Couldn't parse the JSON file. Check the data type")
                        }
                    }
                    else {
                        print("Couldn't parse the JSON file. Check the data type")
                    }
                }
                
                
            case .failure(let apiError):
                print("Failed", apiError)
            }
        }
    }
    
    
}

extension Data {
    func toJSON() -> [String:Any]? {
//        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
//        return try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        return try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}
