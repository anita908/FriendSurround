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

    var phoneFormat: String {
        let areaCode = self.prefix(3)
        let prefix = self.index(self.startIndex, offsetBy: 3) ..< self.index(self.startIndex, offsetBy: 6)
        let lineNumber = self.index(self.startIndex, offsetBy: 6) ..< self.index(self.startIndex, offsetBy: 10)

        return "(\(areaCode)) \(self[prefix])-\(self[lineNumber])"
    }
}
