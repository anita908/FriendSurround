//
//  SetUpPhoneNumberView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI
import iPhoneNumberField

struct SetUpPhoneNumberView: View {
    @State var phoneNumber: String = ""
    @State var isEditing: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                iPhoneNumberField("Enter your phone number", text: $phoneNumber, isEditing: $isEditing)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .font(UIFont(size: 30, weight: .light, design: .monospaced))
                    .maximumDigits(10)
                    .foregroundColor(Color.pink)
                    .clearButtonMode(.whileEditing)
                    .onClear { _ in isEditing.toggle() }
                    .accentColor(Color(0xFFB186))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                
                NavigationLink(destination: PhoneVerificationView(phoneNumber: phoneNumber)) {
                       Text("Verify phone number via SMS")
                    }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 70)
                        .background(Color(0xFFB186))
                        .cornerRadius(15.0)
                        .shadow(radius: 5.0, x: 10, y: 5)
                        .padding()
                
                Text("By continuing, you agree to our Terms and acknowledge receipt of the information in our Privacy Policy and that Joya will process your personal information as described in that Policy. Message and data rates may apply.")
                    .padding()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct SetUpPhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpPhoneNumberView()
    }
}
