//
//  FriendDetailView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import SwiftUI

struct FriendDetailView: View {
    
    var user: User
    
    @EnvironmentObject var friendViewModel: FriendViewModel
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Spacer()
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding()
                        Spacer()
                    }
                    
                    Section {
                        List {
                            HStack {
                                Text("Name")
                                    .layoutPriority(1)
                                Spacer()
                                Text("\(user.firstName) \(user.lastName)")
                                    .multilineTextAlignment(.trailing)
                            }
                            
                            HStack {
                                Text("How you know them: ")
                                    .layoutPriority(1)
                                Spacer()
                                EditableText(
                                    text: "\(user.connection)",
                                    isEditing: editMode.isEditing,
                                    textAlignment: .trailing
                                ) { updatedText in
                                    friendViewModel.updateConnection(connection: updatedText, for: user)
                                }
                            }
                        }
                    }
                }
                
                if editMode.isEditing {
                    Button(action: {
                        friendViewModel.updateFollow(isFollow: !user.isFollow, for: user)
                    }) {
                        if user.isFollow {
                            Text("UNFOLLOW")
                                .font(.headline)
                                .padding()
                        } else {
                            Text("FOLLOW")
                                .font(.headline)
                        }
                    }
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 70)
                    .background(Color(0xFFB186))
                    .cornerRadius(15.0)
                    .shadow(radius: 5.0, x: 10, y: 5)
                    .padding()
                } else {
                    VStack{
                        NavigationLink("CALL", destination: {
                        })
                            .font(.system(size: 35, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 300, height: 70)
                            .background(Color(0xFFB186))
                            .cornerRadius(15.0)
                            .shadow(radius: 5.0, x: 10, y: 5)
                            .padding()
                        
                        NavigationLink("TEXT", destination: {
                        })
                            .font(.system(size: 35, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 300, height: 70)
                            .background(Color(0xFFB186))
                            .cornerRadius(15.0)
                            .shadow(radius: 5.0, x: 10, y: 5)
                            .padding()
                    }
                    .padding([.vertical], 10)
                }
            }
        }
        .navigationBarTitle(Text("\(user.firstName) \(user.lastName)"), displayMode: .inline)
        .navigationBarItems(
            trailing: EditButton()
        )
        .environment(\.editMode, $editMode)
    }
}

//struct FriendDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDetailView(user:User)
//    }
//}
