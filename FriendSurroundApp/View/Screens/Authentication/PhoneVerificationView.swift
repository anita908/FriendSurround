//
//  PhoneVerificationView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI

struct PhoneVerificationView: View {
    @State var verificationCode: String = ""
    var phoneNumber: String
    
    var body: some View {
        if verificationCode == "0000" {
            SignUpView()
       }
        else {
            VStack {
                TextField("Enter verifcation code", text: $verificationCode)
                    .keyboardType(.phonePad)
                    .frame(width: 300, height: 100)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .padding()
                
                Text("Code sent to \(phoneNumber)")

            }
            Spacer()
        }
    }
}

struct PhoneVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneVerificationView(phoneNumber: "phoneNumber")
    }
}
