//
//  SetUpNameView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI
import GRDB

struct SetUpNameView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State private var showTermsAndPrivacyPolicy = false
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
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
                        TextField("Username", text: $username)
                            .padding()
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                            .padding()
                        TextField("Email", text: $email)
                            .padding()
                            .autocapitalization(.none)
                        TextField("Phone", text: $phone)
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
                HStack{
                    Text("Already have an account? ")
                    Button(action: {sessionManager.showLogin()}){
                        Text("Log in")
                    }
                }
                
                Button("Sign Up", action: {
                    sessionManager.signUp(
                        username: username,
                        phoneNumber: phone,
                        email: email,
                        password: password,
                        firstname: firstName,
                        lastname: lastName)
//                    MenuView().environmentObject(FriendViewModel())
                })
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 70)
                    .background(Color.orange)
                    .cornerRadius(15.0)
                    .shadow(radius: 5.0, x: 10, y: 5)
            }
            .padding([.vertical], 10)
            Text("\(sessionManager.errorMessage)")
                .foregroundColor(Color.red)
            
        }
        .sheet(isPresented: $showTermsAndPrivacyPolicy) {
            showTermsAndPrivacyPolicyView(onDismiss: {
                showTermsAndPrivacyPolicy = false
            })
        }
    }
}

struct SetUpNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpNameView()
    }
}

//Image(systemName: "person")
//Spacer()
//Form {
//    TextField("First name", text: $firstName)
//
//    TextField("Last name", text: $lastName)
//
//    TextField("Email", text: $email)
//}
