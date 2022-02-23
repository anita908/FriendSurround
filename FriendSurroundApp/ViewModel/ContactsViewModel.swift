//
//  Contacts.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/15/22.
//

import Foundation
import Contacts
import SwiftUI

class Contacts: ObservableObject {
    
    @Published var contactsApp: ContactsApp

    init(){
        contactsApp = ContactsApp()
    }
    
    //MARK: Accessing the model
    
    var contacts: Array<ContactsApp.Contact>{
        return contactsApp.contacts
    }
    
}
