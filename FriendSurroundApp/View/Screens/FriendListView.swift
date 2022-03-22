//
//  FriendListView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import SwiftUI

struct FriendListView: View {
    
    @EnvironmentObject var friendViewModel: FriendViewModel
    @ObservedObject var userDataManager = UserDataManager()
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(userDataManager.userData.friends, id: \.self) { friend in
                        NavigationLink(
                            destination:
                                FriendDetailView(user: friend).environmentObject(FriendViewModel())
                        ) {
                            HStack {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Spacer()
                                VStack {
                                    Text("\(friend["firstName"] ?? "") \(friend["lastName"] ?? "")")
                                        .layoutPriority(1)
                                    Text("Phone \(friend["phone"]?.phoneFormat ?? "")")
                                        .layoutPriority(1)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                    }
                    .onDelete{ IndexSet in
                        IndexSet.forEach { friendViewModel.removeFriend(at: $0) }
                    }
                }
            }
        }
        .onAppear(){
            print("nearbyFriends")
            print(userDataManager.userData.nearbyFriends)
        }
        .navigationBarTitle("Friend List", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination:
                        AddFriends(contactsApp: Contacts())
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
