//
//  SetUpNameView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI
import GRDB

struct SetUpNameView: View {
    @EnvironmentObject var friendViewModel: FriendViewModel
    
    var phoneNumber: String
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State private var showTermsAndPrivacyPolicy = false
    @State private var handleNext = false
    
    var body: some View {
        
        if handleNext == true {
            MenuView()
        } else {
            VStack {
                Form {
                    HStack {
                        VStack {
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                                .padding()
                            
                            Button(action: {}) {
                                Text("Add Photo")
                                    .padding()
                            }
                            .foregroundColor(.white)
                            .background(Color.orange)
                        }
                        .border(Color.black)
                        .cornerRadius(5.0)
                       
                        VStack {
                            TextField("First name", text: $firstName)
                                .padding()
                        
                            TextField("Last name", text: $lastName)
                                .padding()
                        
                            TextField("Email", text: $email)
                                .padding()
                        }
                    }
                    
                    Button(action: {
                        showTermsAndPrivacyPolicy = true
                    }, label: {
                        (Text("By continuing you agree to our ")
                            + Text("Terms ")
                                .foregroundColor(Color.blue)
                            + Text(" and ")
                         + Text("Privacy Policy")
                            .foregroundColor(Color.blue)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size: 14, weight: .medium))
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                    })
                        .padding([.vertical], 10)
                }
                 
                VStack {
                    Button(action: {
                        saveInfo()
                    }, label: {
                        (Text("Next"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15.0)
                            .shadow(radius: 5.0, x: 10, y: 5)
                    })
                }
                .padding([.vertical], 10)
            }
            .sheet(isPresented: $showTermsAndPrivacyPolicy) {
                showTermsAndPrivacyPolicyView(onDismiss: {
                    showTermsAndPrivacyPolicy = false
                })
            }
        }
    }
    private func saveInfo(){
        friendViewModel.append(User(firstName: firstName, lastName: lastName, phone: phoneNumber, connection: "", email: email, type: 0))
        handleNext = true
    }
}

struct SetUpNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpNameView(phoneNumber: "1231231234")
    }
}
