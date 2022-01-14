//
//  WhoIsCloseView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI

struct WhoIsCloseView: View {
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
        .navigationBarTitle(Text("Who's close"))
    }
                                
    private func addFriend(){
        friendViewModel.append(User(name: "Anita Wu", phone: 1234567890, connection: "school", email: "anita123123@gmail.com"))
    }
}

struct WhoIsCloseView_Previews: PreviewProvider {
    static var previews: some View {
        WhoIsCloseView().environmentObject(FriendViewModel())
    }
}
