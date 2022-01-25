//
//  ContentView.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/10/22.
//

import SwiftUI


struct AddFriends: View {
    
    @ObservedObject var contactsApp: Contacts
    
    var body: some View {
        
        ForEach(contactsApp.contacts, id: \.self) { contact in
            HStack {
                if contact.profileImage != nil {
                    Image(uiImage: UIImage(data: contact.profileImage!)!)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                }
                else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Text(contact.fullName)
                Text(contact.phoneNumber)
                
            }
            
        }
    }
}

struct AddFriends_Previews: PreviewProvider {
    static var previews: some View {
        AddFriends(contactsApp: Contacts())
    }
}
