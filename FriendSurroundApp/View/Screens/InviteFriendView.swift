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
        friendViewModel.append(User(firstName: "Anita", lastName: "Wu", phone: "1231231234", connection: "school", email: "anita123123@email.com", type: 1))
    }
}

struct InviteFriendView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendView()
    }
}
