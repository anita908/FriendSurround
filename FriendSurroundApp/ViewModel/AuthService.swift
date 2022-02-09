//
//  AuthService.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/3/22.
//

import Foundation
import Amplify

class AuthService: ObservableObject {
    @Published var isSignedIn = false
    
    func checkSessionStatus(){
        _ = Amplify.Auth.fetchAuthSession { [weak self] result in
            switch result {
            case .success(let session):
                print(session)
                DispatchQueue.main.async {
                    self?.isSignedIn = session.isSignedIn
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
