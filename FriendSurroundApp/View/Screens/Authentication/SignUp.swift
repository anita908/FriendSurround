//
//  SetUpNameView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI
import GRDB

struct SignUpView: View {
    @EnvironmentObject var friendViewModel: FriendViewModel
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State private var showTermsAndPrivacyPolicy = false
    @State private var handleNext = false
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                VStack {
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90, alignment: .center)
                        .edgesIgnoringSafeArea(.all)
                    
                    Button(action: {
                        self.isShowPhotoLibrary = true
                    }) {
                        Text("Add Photo")
                            .font(.headline)
                            .padding()
                    }
                    .foregroundColor(.white)
                    .background(Color(0xFFB186))
                }
                .border(Color.black)
                .cornerRadius(5.0)
                .sheet(isPresented: $isShowPhotoLibrary) {
                    ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
                }
               
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
            .padding()
            .padding(.top, -200)
            
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
            .sheet(isPresented: $showTermsAndPrivacyPolicy) {
                showTermsAndPrivacyPolicyView(onDismiss: {
                    showTermsAndPrivacyPolicy = false
                })
            }
            
            Spacer()
            
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
    }
    
}

struct SetUpNameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
