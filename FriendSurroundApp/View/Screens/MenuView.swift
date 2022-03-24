//
//  MenuView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//
import Amplify
import SwiftUI

struct MenuView: View {
    
    let user: AuthUser
    
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var friendViewModel: FriendViewModel
    @EnvironmentObject var contactsManager: ContactsManager
    
    //Accessiblity Settings
    @ScaledMetric(relativeTo: .largeTitle) var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    Text("FriendSurround")
                        .font(.largeTitle)
                        .foregroundColor(Color(0xFFB186))
                        .listRowBackground(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: WhoIsCloseView().environmentObject(FriendViewModel()))
                            {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                            
                            HStack {
                                Text("Who's Close").font(.system(size: 25 * scale, weight: .bold, design: .default))
                                    .accessibilityAddTraits(.isButton)
                            }
                        }
                        .padding()
                    }
                }
                .listRowBackground(Color(0xFFB186))
                .padding()
                
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: FriendListView().environmentObject(FriendViewModel()))
                            {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                            
                            HStack {
                                Text("My Friends").font(.system(size: 25 * scale, weight: .bold, design: .default))
                                    .accessibilityAddTraits(.isButton)
                            }
                        }
                        .padding()
                    }
                }
                .listRowBackground(Color(0xFFB186))
                .padding()
                
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: AddFriends())
                            {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                            
                            HStack {
                                Text("Add a friend").font(.system(size: 25 * scale, weight: .bold, design: .default))
                                    .accessibilityAddTraits(.isButton)
                            }
                        }
                        .padding()
                    }
                }
                .listRowBackground(Color(0xFFB186))
                .padding()
                
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: MyAccountView().environmentObject(ApiGateway()))
                            {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                            
                            HStack {
                                Text("My Account").font(.system(size: 25 * scale, weight: .bold, design: .default))
                                    .accessibilityAddTraits(.isButton)
                            }
                        }
                        .padding()
                    }
                    
                }
                .listRowBackground(Color(0xFFB186))
                .padding()
            
                Button("Sign Out", action: sessionManager.signOut)
            }
            .background(Color.white)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    
    static var previews: some View {
        MenuView(user: DummyUser())
    }
}
