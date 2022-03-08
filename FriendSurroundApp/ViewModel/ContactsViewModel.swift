//
//  Contacts.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/15/22.
//

import Foundation
import Contacts
import SwiftUI
import zlib

class Contacts: ObservableObject {
    
    @Published var contactsApp: ContactsApp
    var apiGateway = ApiGateway()

    init(){
        print("new contacts")
        contactsApp = ContactsApp()
        findAppUsers()
    }
    
    //MARK: Accessing the model
    
    var newContacts: Array<ContactsApp.Contact> = [ContactsApp().contacts[0]]
    
    func findAppUsers (){
        let phoneList: Array<String> = []
        var contacts = ContactsApp().contacts
        
        apiGateway.comparePhoneContactsToUsers(for: phoneList, completionHandler: { (contactsInDatabase) -> Void in
            //Flagging any iPhone contacts that are using the App
            if contactsInDatabase != [] {
                for index in 0..<contacts.count {
                    for contactInDatabase in contactsInDatabase {
                        if contacts[index].phoneNumberDigits == contactInDatabase["phone"] {
                            contacts[index].appUser = true
                        }
                    }
                }
                print("new contacts!")
                print(contacts)
                self.newContacts = contacts
            }
            

        })
    }
    
}
