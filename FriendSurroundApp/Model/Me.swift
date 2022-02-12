//
//  Me.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/25/22.
//

import Foundation

struct Me: Identifiable, Codable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phone :String
    var email: String
}



