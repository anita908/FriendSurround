//
//  Contacts.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/6/22.
//

import Foundation
import Contacts
import Amplify
import AmplifyPlugins

class ContactsApp {
    
    var contacts: Array<Contact>
    
    static let shared = ContactsApp.init()
    
    init(){
        contacts = Array<Contact>()
//        let cnContacts = getCNContacts()
//        contacts = convertCNContactData(cnContacts)
    }
    
    enum FriendshipStatus: String {
        case requestReceived
        case requestSent
        case notFriends
        case notAnAppUser
        case friends
        
        private var sortOrder: Int {
            switch self {
                case .requestReceived:
                    return 0
                case .requestSent:
                    return 1
                case .notFriends:
                    return 2
                case .notAnAppUser:
                    return 3
                case .friends:
                    return 4
            }
        }
        
        static func <(lhs: FriendshipStatus, rhs: FriendshipStatus) -> Bool {
               return lhs.sortOrder < rhs.sortOrder
            }
    }

    struct Contact: Hashable {
        
        fileprivate(set) var id = UUID()
        
        fileprivate(set) var fullName: String = ""
        
        fileprivate(set) var phoneNumber: String? = ""
        
        fileprivate(set) var phoneNumberDigits: String? = ""
        
        fileprivate(set) var profileImage: Data? = nil
        
        var username: String? = ""
        
        var friendshipStatus: FriendshipStatus = .notAnAppUser
        
    }

    func updateContacts() {
        self.contacts = Array<Contact>()
        let cnContacts = getCNContacts()
        self.contacts = convertCNContactData(cnContacts)
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
        var contact = Contact()
        
        for cnContact in cnContacts {
            contact.fullName = cnContact.givenName + " " + cnContact.middleName + " " + cnContact.familyName
            
            if cnContact.imageDataAvailable {
                contact.profileImage = cnContact.imageData
            }
            else {
                contact.profileImage = nil
            }
            
            if cnContact.phoneNumbers.isEmpty != true {
                // If we have a mobile phone number, use that by default. Otherwise, use whichever number is on top of the list.
                if let phone = cnContact.phoneNumbers.first(where: {$0.label == "_$!<Mobile>!$_"}){
                    contact.phoneNumberDigits = String(phone.value.stringValue.digits.suffix(10))
                    contact.phoneNumber = phone.value.stringValue
                }
                else {
                    contact.phoneNumberDigits = String(cnContact.phoneNumbers[0].value.stringValue.digits.suffix(10))
                    contact.phoneNumber = cnContact.phoneNumbers[0].value.stringValue
                }
            }
            else {
                contact.phoneNumberDigits = "0000000000"
                contact.phoneNumber = ""
            }

            contacts.append(contact)
        }

        return contacts
    }
    
}
