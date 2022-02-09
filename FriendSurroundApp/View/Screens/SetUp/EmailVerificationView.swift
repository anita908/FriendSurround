//
//  EmailVerificationView.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/5/22.
//

import SwiftUI

struct EmailVerificationView: View {
    
    @State var verificationCode: String = ""
    
    @EnvironmentObject var sessionManager: SessionManager
    
    var username: String
    var email: String
    var body: some View {
        if verificationCode == "0000" {
            SetUpNameView()
       }
        else {
            VStack {
                Text("Username: \(username)")
                Text("A code was sent to \(email)")
                TextField("Enter verification code", text: $verificationCode)
                    .keyboardType(.phonePad)
                    .frame(width: 350, height: 50)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .padding()
                Button("Confirm", action:{
                    sessionManager.confirm (
                        username: username,
                        code: verificationCode)
                })
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 70)
                    .background(Color.orange)
                    .cornerRadius(15.0)
                    .shadow(radius: 5.0, x: 10, y: 5)
                
                

            }
            Spacer()
        }
    }
}

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView(username: "user", email: "friendsurround@gmail.com")
    }
}

