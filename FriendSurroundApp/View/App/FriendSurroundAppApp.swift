//
//  FriendSurroundAppApp.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/5/22.
//

import SwiftUI

@main
struct FriendSurroundAppApp: App {
    var body: some Scene {
        WindowGroup {
//            MenuView().environmentObject(FriendViewModel())
            SetUpPhoneNumberView()
        }
    }
}
