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
import Amplify

class Contacts: ObservableObject {
    
    @Published var contactsApp: ContactsApp

    init(){
        contactsApp = ContactsApp.shared
        findAppUsers(for: contactsApp.contacts)
    }
    
    //MARK: Accessing the model
    
    var newContacts: Array<ContactsApp.Contact> = [ContactsApp().contacts[0]]
    
    func refreshModel(){
        contactsApp.updateContacts()
        findAppUsers(for: contactsApp.contacts)
    }
    
    func createPhoneList(from contacts: Array<ContactsApp.Contact>) -> [String] {
        var phoneList: [String] = []
        for contact in contacts {
            phoneList.append(contact.phoneNumberDigits)
        }
        return phoneList
    }
    
    //I want to put this into the APIGateway ViewModel and update the shared Contacts list, but this was the only way I could get it to work.
    func findAppUsers(for contacts: Array<ContactsApp.Contact>) {
        let phoneList = createPhoneList(from: contacts)
        
        let message = #"{ "phoneList": \#(phoneList)}"#
        let request = RESTRequest(path: "/checknumbers", body: message.data(using: .utf8))
        var contacts = ContactsApp().contacts
        
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                if let json = data.toJSON() {
                    // try to read out a string array
                    if let contactsInDatabase = json["contacts"] as? [[String:String]] {
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
                            DispatchQueue.main.async {
                                self.objectWillChange.send()
                            }
                            
                        }
                    }
                    else {
                        print("Couldn't parse the JSON file. Check the data type")
                    }
                }

            case .failure(let apiError):
                print("Failed", apiError)
            }
        }

    }
    
    
}
