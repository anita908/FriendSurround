//
//  SetUpNameView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI
import iPhoneNumberField

struct SignUpView: View {
    @EnvironmentObject var friendViewModel: FriendViewModel
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordCheck: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State private var showTermsAndPrivacyPolicy = false
    @State private var handleNext = false
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    @State var error: String = ""
    @State var isEditing: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
    //                VStack {
    //                    Image(uiImage: self.image)
    //                        .resizable()
    //                        .scaledToFill()
    //                        .frame(width: 90, height: 90, alignment: .center)
    //                        .edgesIgnoringSafeArea(.all)
    //
    //                    Button(action: {
    //                        self.isShowPhotoLibrary = true
    //                    }) {
    //                        Text("Add Photo")
    //                            .font(.headline)
    //                            .padding()
    //                    }
    //                    .foregroundColor(.white)
    //                    .background(Color(0xFFB186))
    //                }
    //                .border(Color.black)
    //                .cornerRadius(5.0)
    //                .sheet(isPresented: $isShowPhotoLibrary) {
    //                    ImagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
    //                }
                Text("Sign Up")
                    .font(.system(size: 25, weight: .semibold))
               
                VStack {
                    TextField("First name", text: $firstName)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(6.0)
                        .disableAutocorrection(true)
                    TextField("Last name", text: $lastName)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(6.0)
                        .disableAutocorrection(true)
                    TextField("Email", text: $email)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(6.0)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    iPhoneNumberField(text: $phone, isEditing: $isEditing)
                        .flagHidden(true)
                        .flagSelectable(true)
                        .maximumDigits(10)
                        .clearButtonMode(.whileEditing)
                        .onClear { _ in isEditing.toggle() }
                        .prefixHidden(false)
                        .flagSelectable(false)
                        .accessibility(label: Text("Phone Number"))
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(6.0)
                    TextField("Username", text: $username)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(6.0)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $password)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(6.0)
                    SecureField("Re-enter Password", text: $passwordCheck)
                        .padding()
                        .border(.gray, width: 1)
                        .cornerRadius(6.0)
                }
            }
            .padding()
            
    //        Button(action: {
    //            showTermsAndPrivacyPolicy = true
    //        }, label: {
    //            (Text("By continuing you agree to our ")
    //                + Text("Terms ")
    //                    .foregroundColor(Color.blue)
    //                + Text(" and ")
    //             + Text("Privacy Policy")
    //                .foregroundColor(Color.blue)
    //                )
    //                .frame(maxWidth: .infinity, alignment: .leading)
    //                .font(Font.system(size: 14, weight: .medium))
    //                .foregroundColor(Color.black)
    //                .fixedSize(horizontal: false, vertical: true)
    //        })
    //        .padding(.vertical)
    //        .padding([.vertical], 10)
    //            .sheet(isPresented: $showTermsAndPrivacyPolicy) {
    //                showTermsAndPrivacyPolicyView(onDismiss: {
    //                    showTermsAndPrivacyPolicy = false
    //                })
    //            }
            
            Spacer()
            
            VStack {
                HStack{
                    Text("Already have an account? ")
                    Button(action: {sessionManager.showLogin()}){
                        Text("Log in")
                    }
                }
                
                Button(action: {
                    sigupCheck()
                }) {
                    HStack {
                        Spacer()
                        Text("Create Account")
                        Spacer()
                    }
                }
                .font(.system(size: 25, weight: .semibold))
                .frame(width: 300, height: 70)
                .foregroundColor(.white)
                .background(Color(0xFFB186))
                .cornerRadius(15.0)
                .shadow(radius: 5.0, x: 10, y: 5)
                .padding(.top)
    //                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || phone.isEmpty )
            }
        }
//        .padding([.vertical], 10)
        if sessionManager.signupErrorMessage != "" {
            Text("\(sessionManager.signupErrorMessage)")
                .foregroundColor(Color.red)
                .padding()
        } else if error != "" {
            Text("\(error)")
                .foregroundColor(Color.red)
                .padding()
        }
    }
    
    private func sigupCheck() {
        print(phone)
        let trimPhone = phone
            .components(separatedBy:CharacterSet.decimalDigits.inverted)
            .joined()
        
        
        if firstName == "" {
            error = "Please enter your first name"
        } else if lastName == "" {
            error = "Please enter your last name"
        } else if email == "" || !sessionManager.isEmailValid(email) {
            error = "Please enter a valid email"
        } else if phone == "" || trimPhone.count != 10{
            error = "Please enter a valid phone number"
        } else if password != passwordCheck {
            error = "Passwords don't match"
        }
        else {
            error = ""
        }
        
        print(trimPhone.count)
        
        if error == "" {
            sessionManager.signUp(
                username: username,
                phoneNumber: "+1" + phone
                    .components(separatedBy:CharacterSet.decimalDigits.inverted)
                    .joined(),
                email: email,
                password: password,
                firstname: firstName,
                lastname: lastName)
        }
    }
}

struct SetUpNameView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
