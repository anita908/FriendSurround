//
//  ContentView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/5/22.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("FriendSurround")
                        .font(.largeTitle).foregroundColor(Color(0xFFB186))
                        .padding([.top, .bottom], 40)
                }
                
                Spacer()
                        
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email", text: self.$email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5, x: 10, y: 5)
                    
                    SecureField("Password", text: self.$password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5, x: 10, y: 5)
                    Text("forgot password?")
                        .padding(.trailing)
                }.padding([.leading, .trailing], 27.5)
                
                Spacer()
                
                NavigationLink("Sign In", destination: {
                    MenuView()
                })
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(0xFFB186))
                    .cornerRadius(15.0)
                    .shadow(radius: 5.0, x: 10, y: 5)

                Spacer()
                
                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                    Button(action: {}) {
                        Text("Sign Up")
                            .foregroundColor(.black)
                    }
                }
            }
            

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
