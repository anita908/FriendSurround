//
//  User.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import Foundation
import CoreLocation

struct User: Codable {
    var username: String
    var firstName: String
    var lastName: String
    var phone :String
    var email: String
    var userLocation: String
    var pendingFriendRequestsIn: Array<[String:String]>
    var pendingFriendRequestsOut: Array<[String:String]>
    var friends: Array<[String:String]>
    var createdDate: String
    var deletedDate: String
    var deleted: Bool
    var blockedPeople: Array<[String:String]>
}

