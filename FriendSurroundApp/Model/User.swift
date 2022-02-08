//
//  User.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phone :String
    var connection: String
    var email: String
    var type: Int
    var isFollow: Bool
}
