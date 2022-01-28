//
//  MenuView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI

struct MenuView: View {
    
    @ScaledMetric(relativeTo: .largeTitle) var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: WhoIsCloseView())
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
                .padding()
                
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: FriendListView())
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
                .padding()
                
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: AddFriends(contactsApp: Contacts()))
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
                .padding()
                
                Section {
                    List {
                        ZStack {
                            NavigationLink(destination: MyAccountView())
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
                .padding()
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
        }
        
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
