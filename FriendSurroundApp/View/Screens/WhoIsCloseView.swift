//
//  WhoIsCloseView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI

struct WhoIsCloseView: View {
    @EnvironmentObject var friendViewModel: FriendViewModel
    @ObservedObject var userDataManager = UserDataManager()
    
    var body: some View {
        Form {
            Section {
                List {
                    ForEach(userDataManager.userData.nearbyFriends, id: \.self) { user in
                        NavigationLink(
                            destination:
//                                FriendDetailView(user:user)
                                    EmptyView()
                        ) {
                            HStack {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Spacer()
                                VStack {
                                    Text("\(user["firstName"] ?? "") \(user["lastName"] ?? "")")
                                        .layoutPriority(1)
                                    Text("Phone \(user["phone"]?.phoneFormat ?? "")")
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
        .navigationBarTitle("Who's Close", displayMode: .inline)
    }
}

struct WhoIsCloseView_Previews: PreviewProvider {
    static var previews: some View {
        WhoIsCloseView().environmentObject(FriendViewModel())
    }
}
