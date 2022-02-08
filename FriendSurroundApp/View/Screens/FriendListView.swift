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
                        if user.type == 1 {
                            NavigationLink(
                                destination:
                                    FriendDetailView(user:user).environmentObject(FriendViewModel())
                            ) {
                                HStack {
                                    Image(systemName: "person")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                    Spacer()
                                    VStack {
                                        Text("\(user.firstName) \(user.lastName)")
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
                    .onDelete{ IndexSet in
                        IndexSet.forEach { friendViewModel.removeFriend(at: $0) }
                    }
                }
            }
        }
        .navigationBarTitle("Friend List", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination:
                        InviteFriendView().environmentObject(FriendViewModel())
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
