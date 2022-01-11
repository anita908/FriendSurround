//
//  User.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var phone :Int
    var connection: String
    var email: String
}

