//
//  ContentView.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/10/22.
//

import SwiftUI

struct AddFriends: View {
    @ObservedObject var contactsApp: Contacts
    @ScaledMetric(relativeTo: .largeTitle) var scale: CGFloat = 1.0
    
    @ViewBuilder
    var body: some View {
        mass_invite_options
        contacts
        Spacer()
            .navigationTitle("Add Friends")
    }
    
    var mass_invite_options: some View {
        HStack {
            NavigationLink("FRIEND REQUEST ALL", destination: {
            })
                .font(.system(size: 10 * scale, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 100 * scale, height: 30 * scale)
                .background(Color(0xFFB186))
                .cornerRadius(5.0)
                .shadow(radius: 5.0, x: 10, y: 5)
                .padding()
            Spacer()
            NavigationLink("INVITE ALL CONTACTS", destination: {
            })
                .font(.system(size: 10 * scale, weight: .semibold))
                .foregroundColor(.black)
                .frame(width: 100 * scale, height: 30 * scale)
                .background(Color.white)
                .cornerRadius(5.0)
                .shadow(radius: 5.0, x: 10, y: 5)
                .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(0xFFB186), lineWidth: 2))
                .padding()
        }
    }
    
    var contacts: some View {
        ScrollView(.vertical){
            LazyVStack(alignment: .leading){
                ForEach(contactsApp.contacts, id: \.self) { contact in
                    HStack {
                        if contact.profileImage != nil {
                            Image(uiImage: UIImage(data: contact.profileImage!)!)
                                                .resizable()
                                                .frame(width: 50 * scale, height: 50 * scale)
                                                .accessibility(hidden: true)
                        }
                        else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50 * scale, height: 50 * scale)
                                .accessibility(hidden: true)
                        }
                        VStack(alignment: .leading){
                            Text(contact.fullName)
                            Text(contact.phoneNumber)
                        }
                        .accessibilityElement(children: .combine)

                        Spacer()
                        VStack(alignment: .trailing){
                            
                            //Change these if statements when we can distinguish whether user is on the app or not.
                            if contact.profileImage != nil {
                                NavigationLink("INVITE TO APP", destination: {
                                })
                                    .font(.system(size: 10 * scale, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(width: 85 * scale, height: 30 * scale)
                                    .background(Color.white)
                                    .cornerRadius(5.0)
                                    .shadow(radius: 5.0, x: 10, y: 5)
                                    .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color(0xFFB186), lineWidth: 2))
                            }
                            else {
                                NavigationLink("FRIEND REQUEST", destination: {
                                })
                                    .font(.system(size: 10 * scale, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(width: 85 * scale, height: 30 * scale)
                                    .background(Color(0xFFB186))
                                    .cornerRadius(5.0)
                                    .shadow(radius: 5.0, x: 10, y: 5)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct AddFriends_Previews: PreviewProvider {
    static var previews: some View {
        AddFriends(contactsApp: Contacts())
    }
}
