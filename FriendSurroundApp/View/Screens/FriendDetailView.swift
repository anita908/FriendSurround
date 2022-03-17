//
//  FriendDetailView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import SwiftUI

struct FriendDetailView: View {
    
    var user: [String : String]
    
    @EnvironmentObject var friendViewModel: FriendViewModel
    @State private var editMode: EditMode = .inactive
    @State private var showMessageModel = false
    @State private var showPhoneModel = false
    @State private var invitePhoneNumber = "801850245"
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Spacer()
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding()
                        Spacer()
                    }
                    
                    Section {
                        List {
                            HStack {
                                Text("Name")
                                    .layoutPriority(1)
                                Spacer()
                                Text("\(user["firstName"] ?? "") \(user["lastName"] ?? "")")
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Phone")
                                    .layoutPriority(1)
                                Spacer()
                                Text("\(user["phone"]?.phoneFormat ?? "")")
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("username")
                                    .layoutPriority(1)
                                Spacer()
                                Text("\(user["username"] ?? "")")
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("email")
                                    .layoutPriority(1)
                                Spacer()
                                Text("\(user["email"] ?? "")")
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
               
                VStack{
                    Button("Call") {
                        let phone = "tel://"
                        let phoneNumberformatted = phone + "\(user["phone"]?.phoneFormat ?? "")"
                        guard let url = URL(string: phoneNumberformatted) else { return }
                        UIApplication.shared.open(url)
                       }
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 70)
                        .background(Color(0xFFB186))
                        .cornerRadius(15.0)
                        .shadow(radius: 5.0, x: 10, y: 5)
                        .padding()
                    
                    Button("Text") {
                        showMessageModel = true
                        invitePhoneNumber = "\(user["phone"]?.phoneFormat ?? "")"
                    }
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 70)
                        .background(Color(0xFFB186))
                        .cornerRadius(15.0)
                        .shadow(radius: 5.0, x: 10, y: 5)
                        .padding()
                }
                .padding([.vertical], 10)
                
            }
            .sheet(isPresented: $showPhoneModel) {
                MessageComponentView(recicipents: [invitePhoneNumber], body: "") {
                    messageSent in
                    showPhoneModel = false
                }
            }
            .sheet(isPresented: $showMessageModel) {
                MessageComponentView(recicipents: [invitePhoneNumber], body: "") {
                    messageSent in
                    showMessageModel = false
                }
            }
        }
        .navigationBarTitle(Text("\(user["firstName"] ?? "") \(user["lastName"] ?? "")"), displayMode: .inline)
    }
}

//struct FriendDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDetailView(user:User)
//    }
//}
