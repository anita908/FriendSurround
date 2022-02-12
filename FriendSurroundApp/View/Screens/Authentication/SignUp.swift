//
//  SetUpNameView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI
import GRDB

<<<<<<< HEAD:FriendSurroundApp/View/Screens/Authentication/SignUp.swift
struct SignUpView: View {
=======
struct SetUpNameView: View {
    @EnvironmentObject var friendViewModel: FriendViewModel
    
    var phoneNumber: String
    
>>>>>>> origin/Anita05:FriendSurroundApp/View/Screens/SetUp/SetUpNameView.swift
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State private var showTermsAndPrivacyPolicy = false
<<<<<<< HEAD:FriendSurroundApp/View/Screens/Authentication/SignUp.swift
    @EnvironmentObject var sessionManager: SessionManager
=======
    @State private var handleNext = false
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
>>>>>>> origin/Anita05:FriendSurroundApp/View/Screens/SetUp/SetUpNameView.swift
    
    var body: some View {
        
        if handleNext == true {
            MenuView()
        } else {
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
<<<<<<< HEAD:FriendSurroundApp/View/Screens/Authentication/SignUp.swift
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
=======
                .padding([.vertical], 10)
                .sheet(isPresented: $showTermsAndPrivacyPolicy) {
                    showTermsAndPrivacyPolicyView(onDismiss: {
                        showTermsAndPrivacyPolicy = false
                    })
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        saveInfo()
                    }, label: {
                        (Text("Next"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 300, height: 70)
                            .background(Color(0xFFB186))
                            .cornerRadius(15.0)
                            .shadow(radius: 5.0, x: 10, y: 5)
                    })
                }
                .padding([.vertical], 10)
            }
>>>>>>> origin/Anita05:FriendSurroundApp/View/Screens/SetUp/SetUpNameView.swift
        }
    }
    
    private func saveInfo(){
        friendViewModel.append(User(firstName: firstName, lastName: lastName, phone: phoneNumber, connection: "", email: email, type: 0, isFollow: false))
        handleNext = true
    }
}

struct SetUpNameView_Previews: PreviewProvider {
    static var previews: some View {
<<<<<<< HEAD:FriendSurroundApp/View/Screens/Authentication/SignUp.swift
        SignUpView()
=======
        SetUpNameView(phoneNumber: "1231231234")
>>>>>>> origin/Anita05:FriendSurroundApp/View/Screens/SetUp/SetUpNameView.swift
    }
}
