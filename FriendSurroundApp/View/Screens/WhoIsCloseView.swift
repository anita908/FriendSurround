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
                        if user.type == 1 {
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
