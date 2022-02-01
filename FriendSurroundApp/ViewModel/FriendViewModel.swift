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
        friendList.addPerson(user)
        save()
    }
    
    func deleteAccount() {
        friendList.deleteAccount()
        save()
    }
    
    func updateConnection(connection: String, for user: User) {
        friendList.updateConnection(connection, for: user)
        save()
    }
    
    func updateMyFirstName(firstName: String, for user: User) {
        friendList.updateMyFirstName(firstName, for: user)
        save()
    }
    
    func updateMyLastName(lastName: String, for user: User) {
        friendList.updateMyLastName(lastName, for: user)
        save()
    }
    
    func updateMyEmail(email: String, for user: User) {
        friendList.updateMyEmail(email, for: user)
        save()
    }
    
    func updateMyPhone(phone: String, for user: User) {
        friendList.updateMyPhone(phone, for: user)
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


