//
//  MenuView.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/13/22.
//

import SwiftUI

struct MenuView: View {
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
                                Text("Who's CLose").font(.system(size: 25, weight: .bold, design: .default))
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
                                Text("My Friends").font(.system(size: 25, weight: .bold, design: .default))
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
                                Text("Add a friend").font(.system(size: 25, weight: .bold, design: .default))
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
                                Text("My Account").font(.system(size: 25, weight: .bold, design: .default))
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
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
