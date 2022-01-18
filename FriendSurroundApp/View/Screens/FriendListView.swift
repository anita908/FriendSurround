//
//  FriendListView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import SwiftUI

struct FriendListView: View {
    
    @EnvironmentObject var friendViewModel: FriendViewModel
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(friendViewModel.users) { user in
                        NavigationLink(
                            destination:
                                FriendDetailView(user:user)
                        ) {
                            HStack {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Spacer()
                                VStack {
                                    Text("\(user.name)")
                                        .layoutPriority(1)
                                    Text("From \(user.connection)")
                                        .layoutPriority(1)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarTitle("Friend List", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination:
                        InviteFriendView()
                ) {
                    Text("Invite")
                }
            }
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView().environmentObject(FriendViewModel())
    }
}
