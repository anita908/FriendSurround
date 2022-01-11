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

    mutating func addFriend(_ user: User) {
        users.append(user)
    }
//
//    mutating func removePushupTally(_ pushupTally: PushupTally) {
//        if let index =  pushupTallies.firstIndex(where: { pushupTally.id == $0.id }) {
//            pushupTallies.remove(at: index)
//        }
//    }
//
//    mutating func remove(at index: Int) {
//        if index >= 0 && index < pushupTallies.count {
//            pushupTallies.remove(at: index)
//        }
//    }
//
    mutating func updateConnection(_ connection: String, for User: User) {
        if let index = users.firstIndex(where: { User.id == $0.id }) {
            users[index].connection = connection
        }
    }
    
    func save() throws {
        if let jsonData = try? JSONEncoder().encode(users) {
            try jsonData.write(to: fileUrl(), options: .atomic)
        }
    }

    // MARK: - Helpers
    private func compareByName(_ user: User, _ otherUser: User) -> Bool {
        user.name < otherUser.name
    }

    private func fileUrl() throws -> URL {
        return try FileManager.default.url( for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
        .appendingPathComponent("user.data")
    }    
}
