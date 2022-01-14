//
//  SetUpNameView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI

struct SetUpNameView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    
    var body: some View {
        NavigationView {
            

            VStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding()
                
                Form {
                    TextField("First name", text: $firstName)
                
                    TextField("Last name", text: $lastName)
                
                    TextField("Email", text: $email)
                }

                NavigationLink("Next", destination: {
                    MenuView()
                })
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.orange)
                    .cornerRadius(15.0)
                    .shadow(radius: 5.0, x: 10, y: 5)
            }
                

        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
