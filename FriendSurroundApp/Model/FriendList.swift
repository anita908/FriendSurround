//
//  FriendList.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import Foundation

struct FriendList {
    
    // MARK: - Prperties
    var users: [User] = []
    
    
    // MARK: - Initializers
    
    init() {
        
        if let jsonData = try? Data(contentsOf: fileUrl()),
        let userList = try? JSONDecoder().decode([User].self, from: jsonData) {
            users = userList.sorted(by: compareByName)
        }
    }
    
//    // MARK: - CRUD operations

    mutating func addPerson(_ user: User) {
        users.append(user)
    }
    
    mutating func remove(at index: Int) {
        if index >= 0 && index < users.count {
            users.remove(at: index)
        }
    }
    
    mutating func deleteAccount() {
        users.removeAll()
    }

    mutating func updateConnection(_ connection: String, for User: User) {
        if let index = users.firstIndex(where: { User.id == $0.id }) {
            users[index].connection = connection
        }
    }
    
    mutating func updateMyFirstName(_ firstName: String, for User: User) {
        if let index = users.firstIndex(where: { User.id == $0.id }) {
            users[index].firstName = firstName
        }
    }
    
    mutating func updateMyLastName(_ lastName: String, for User: User) {
        if let index = users.firstIndex(where: { User.id == $0.id }) {
            users[index].lastName = lastName
        }
    }
    
    mutating func updateMyEmail(_ email: String, for User: User) {
        if let index = users.firstIndex(where: { User.id == $0.id }) {
            users[index].email = email
        }
    }
    
    mutating func updateMyPhone(_ phone: String, for User: User) {
        if let index = users.firstIndex(where: { User.id == $0.id }) {
            users[index].phone = phone
        }
    }
    
    mutating func updateFollow(_ isFollow: Bool, for User: User) {
        if let index = users.firstIndex(where: { User.id == $0.id }) {
            users[index].isFollow = isFollow
        }
    }
    
    func save() throws {
        if let jsonData = try? JSONEncoder().encode(users) {
            try jsonData.write(to: fileUrl(), options: .atomic)
        }
    }

    // MARK: - Helpers
    private func compareByName(_ user: User, _ otherUser: User) -> Bool {
        user.lastName < otherUser.lastName
    }

    private func fileUrl() throws -> URL {
        return try FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
        .appendingPathComponent("user.data")
    }    
}
