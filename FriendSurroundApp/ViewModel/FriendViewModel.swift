//
//  FriendViewModel.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import Foundation

class FriendViewModel: ObservableObject {

    @Published var friendList = FriendList()
    @Published var saveError = false
    
    // MARK: - Model access
    
    var users: [User] {
        friendList.users
    }
    
    // MARK: - User Intents
    
    func append(_ user: User) {
        friendList.addFriend(user)
        save()
    }
    
    func updateConnection(connection: String, for user: User) {
        friendList.updateConnection(connection, for: user)
        save()
    }
    
    // MARK: - Helpers
    
    private func save() {
        do {
            try friendList.save()
        } catch {
            // problem
        }
        
        saveError = true
    }
}


