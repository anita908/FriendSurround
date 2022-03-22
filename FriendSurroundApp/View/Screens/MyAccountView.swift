//
//  MyAccountView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/18/22.
//

import SwiftUI

struct MyAccountView: View {
    @EnvironmentObject var apiGateway: ApiGateway
    @EnvironmentObject var sessionManager: SessionManager
    
    @ObservedObject var userDataManager = UserDataManager()
    
    @State private var editMode: EditMode = .inactive
    @State private var handleDeleteAccount: Bool = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phone: String = ""
    @State private var email: String = ""
    @State private var message: String = ""
    
    var body: some View {
        if handleDeleteAccount == true {
            SetUpPhoneNumberView()
        } else {
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
                                    Text("Phone")
                                    Spacer()
                                    EditableText(
                                        text: "\(userDataManager.userData.phone)",
                                        isEditing: editMode.isEditing,
                                        textAlignment: .trailing
                                    ) { updatedText in
                                        phone = updatedText
                                        print(updatedText)
                                    }
                                }
                                HStack {
                                    Text("First Name")
                                    Spacer()
                                    EditableText(
                                        text: "\(userDataManager.userData.firstName)",
                                        isEditing: editMode.isEditing,
                                        textAlignment: .trailing
                                    ) { updatedText in
                                        firstName = updatedText
                                    }
                                }
                                
                                HStack {
                                    Text("Last Name")
                                    Spacer()
                                    EditableText(
                                        text: "\(userDataManager.userData.lastName)",
                                        isEditing: editMode.isEditing,
                                        textAlignment: .trailing
                                    ) { updatedText in
                                        lastName = updatedText
                                    }
                                }
                                HStack {
                                    Text("Email")
                                    Spacer()
                                    EditableText(
                                        text: "\(userDataManager.userData.email)",
                                        isEditing: editMode.isEditing,
                                        textAlignment: .trailing
                                    ) { updatedText in
                                        email = updatedText
                                    }
                                }
                            }
                        }
                    }
                    
                    Text(message)
                        .foregroundColor(.red)
                    
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
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
            .navigationBarTitle(Text("My Account"), displayMode: .inline)
            .navigationBarItems(
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
            .onChange(of: $editMode.wrappedValue, perform: { value in
              if value.isEditing {
                 // Entering edit mode (e.g. 'Edit' tapped)
              } else {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                      if phone.count != 10 && phone != "" {
                          message = "please enter a valid phone number"
                      } else if !sessionManager.isEmailValid(email) && email != "" {
                          message = "please enter a valid email"
                      } else {
                          message = ""
                      }
                      
                      if message == "" {
                          apiGateway.updatePersonalDetail(phone, firstName, lastName, email)
                      }
                      message = "successfully update!"
                  }
              }
            })
        }
    }
    
    private func deleteAccount(){
        handleDeleteAccount = true
    }
}

struct MyAccountView_Previews: PreviewProvider {
    static var previews: some View {
        MyAccountView()
    }
}
