//
//  InviteFriendView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/18/22.
//

import SwiftUI

struct InviteFriendView: View {
    @EnvironmentObject var friendViewModel: FriendViewModel

    var body: some View {
        Button(action: {
           addFriend()
       }, label: {
           Text("Invite")
       })

    }
    
    private func addFriend(){
        friendViewModel.append(User(name: "Anita Wu", phone: 1234567890, connection: "school", email: "anita123123@gmail.com"))
    }
}

struct InviteFriendView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendView()
    }
}
