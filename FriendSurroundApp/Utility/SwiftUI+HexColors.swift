//
//  SwiftUI+HexColors.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/25/22.
//

//Source: https://gist.github.com/aChase55/da4b2ab8e093a12c3c82015ab455ce77

import SwiftUI

extension Color {
    init(_ hex: UInt32, opacity:Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
