//
//  String+Digits.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/13/22.
//

import Foundation

// We can use this extention to remove non-integer characters from phone numbers to store in the database
extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
