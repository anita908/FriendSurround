//
//  UserDataManager.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/23/22.
//

import Foundation

final class UserDataManager: ObservableObject {
    @Published var userData: UserData
    
    init(){
        userData = UserData.shared
    }
    
}
