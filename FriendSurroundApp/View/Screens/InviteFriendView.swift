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
            addFriend(friendViewModel.users.count)
       }, label: {
           Text("Invite")
       })

    }
    
    private func addFriend(_ count: Int){
        friendViewModel.append(User(firstName: "Anita\(count+1)", lastName: "Wu", phone: "1231231234", connection: "school", email: "anita123123@email.com", type: 1, isFollow: true))
    }
}

struct InviteFriendView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendView()
    }
}
