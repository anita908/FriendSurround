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
                                FriendDetailView(user: user).environmentObject(FriendViewModel())
                        ) {
                            HStack {
                                if user.profileImage != nil {
                                    Image(uiImage: UIImage(data: user.profileImage!)!)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                                else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                                Spacer()
                                VStack {
                                    Text("\(user.firstName) \(user.lastName)")
                                        .layoutPriority(1)
                                    Text("Phone \(user.phone.phoneFormat)")
                                        .layoutPriority(1)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                    }
                }
            }
            Section {
                if userDataManager.userData.nearbyFriends.count == 0 {
                    Text("No friends nearby")
                        .listRowBackground(Color.clear)
                        .foregroundColor(Color.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .navigationBarTitle("Who's Close", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Refresh") {
                    userDataManager.updateLocation()
                }
            }
        }
        .onAppear(perform: userDataManager.updateLocation)
    }
}

struct WhoIsCloseView_Previews: PreviewProvider {
    static var previews: some View {
        WhoIsCloseView().environmentObject(FriendViewModel())
    }
}
