//
//  Contacts.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/6/22.
//

import Foundation
import Contacts

struct ContactsApp {

    private(set) var contacts: Array<Contact>
    
    init(){
        contacts = Array<Contact>()
        let cnContacts = getCNContacts()
        contacts = convertCNContactData(cnContacts)
    }
    
    private func getCNContacts () -> [CNContact] {

        var contacts = [CNContact]()
        let keys = [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactImageDataAvailableKey] as [CNKeyDescriptor]

        let request = CNContactFetchRequest(keysToFetch: keys)

        let contactStore = CNContactStore()
        do {
          try contactStore.enumerateContacts(with: request) {
              (contact, stop) in
              // Array containing all unified contacts from everywhere
              contacts.append(contact)
          }
        }
        catch {
          print("unable to fetch contacts")
        }

        return contacts
        
    }
    
    private func convertCNContactData (_ cnContacts: [CNContact]) -> [Contact] {
        
        var contacts: [Contact] = []
        var contact = Contact(fullName: "", phoneNumber: "")
        
        for cnContact in cnContacts {
            contact.fullName = cnContact.givenName + " " + cnContact.middleName + " " + cnContact.familyName
            if cnContact.imageDataAvailable {
                contact.profileImage = cnContact.imageData
            }
            
            // If we have a mobile phone number, use that by default. Otherwise, use whichever number is on top of the list.
            if let phone = cnContact.phoneNumbers.first(where: {$0.label == "$!<Mobile>!$_"}){
                contact.phoneNumber = phone.value.stringValue
            }
            else {
                contact.phoneNumber = cnContact.phoneNumbers[0].value.stringValue
            }
            
            contacts.append(contact)
        }
        print(contacts)
        return contacts
    }
    
    
    struct Contact: Hashable {
        
        fileprivate(set) var id = UUID()
        
        fileprivate(set) var fullName: String
        
        fileprivate(set) var phoneNumber: String
        
        fileprivate(set) var profileImage: Data?
        
    }
    
    
}
