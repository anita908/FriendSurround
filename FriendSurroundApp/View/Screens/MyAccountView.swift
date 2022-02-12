//
//  MyAccountView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/18/22.
//

import SwiftUI

struct MyAccountView: View {
    
    @EnvironmentObject var friendViewModel: FriendViewModel
    @State private var editMode: EditMode = .inactive
    @State private var handleDeleteAccount: Bool = false

    var body: some View {
        if handleDeleteAccount == true {
            SetUpPhoneNumberView()
        } else {
            NavigationView {
                ForEach(friendViewModel.users) { user in
                    if user.type == 0 {
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
                                            Text("Phone")
                                            Spacer()
                                            EditableText(
                                                text: "\(user.email)",
                                                isEditing: editMode.isEditing,
                                                textAlignment: .trailing
                                            ) { updatedText in
                                                friendViewModel.updateMyPhone(phone: updatedText, for: user)
                                            }
                                        }
                                        HStack {
                                            Text("First Name")
                                            Spacer()
                                            EditableText(
                                                text: "\(user.firstName)",
                                                isEditing: editMode.isEditing,
                                                textAlignment: .trailing
                                            ) { updatedText in
                                                friendViewModel.updateMyFirstName(firstName: updatedText, for: user)
                                            }
                                        }
                                        
                                        HStack {
                                            Text("Last Name")
                                            Spacer()
                                            EditableText(
                                                text: "\(user.lastName)",
                                                isEditing: editMode.isEditing,
                                                textAlignment: .trailing
                                            ) { updatedText in
                                                friendViewModel.updateMyLastName(lastName: updatedText, for: user)
                                            }
                                        }
                                        HStack {
                                            Text("Email")
                                            Spacer()
                                            EditableText(
                                                text: "\(user.phone)",
                                                isEditing: editMode.isEditing,
                                                textAlignment: .trailing
                                            ) { updatedText in
                                                friendViewModel.updateMyEmail(email: updatedText, for: user)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack{
                                Button(action: {
                                    deleteAccount()
                                }, label: {
                                    (Text("Delete Account"))
                                        .font(.system(size: 25, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 300, height: 70)
                                        .background(Color(0xFFB186))
                                        .cornerRadius(15.0)
                                        .shadow(radius: 5.0, x: 10, y: 5)
                                        .padding()
                                        
                                })
                                HStack {
                                    Image(systemName: "person.crop.circle.badge.xmark")
                                        .resizable()
                                        .frame(width: 40, height: 40, alignment: .center)
                                        .padding()
                                    NavigationLink("STEALTH MODE", destination: {
                                    })
                                }
                                .font(.system(size: 25, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 300, height: 70)
                                .background(Color.gray)
                                .cornerRadius(15.0)
                                .shadow(radius: 5.0, x: 10, y: 5)
                                .padding()
                            }
                            .padding([.vertical], 10)
                        }
                     }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
            .navigationBarTitle(Text("My Account"), displayMode: .inline)
            .navigationBarItems(
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
    }
    
    private func deleteAccount(){
        friendViewModel.deleteAccount()
        handleDeleteAccount = true
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
