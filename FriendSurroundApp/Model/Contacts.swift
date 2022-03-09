//
//  Contacts.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 1/6/22.
//

import Foundation
import Contacts
import Amplify

struct ContactsApp {
    
    var contacts: Array<Contact>
//    var apiGateway = ApiGateway()
    
    static let shared = ContactsApp.init()
    
    init(){
        contacts = Array<Contact>()
        let cnContacts = getCNContacts()
        contacts = convertCNContactData(cnContacts)
    }
    
    
    struct Contact: Hashable {
        
        fileprivate(set) var id = UUID()
        
        fileprivate(set) var fullName: String = ""
        
        fileprivate(set) var phoneNumber: String = ""
        
        fileprivate(set) var phoneNumberDigits: String = ""
        
        fileprivate(set) var profileImage: Data?
        
        var appUser: Bool = false
        
    }
    
    
    mutating func updateContacts() {
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
        var phoneList: [String] = []
        
        for cnContact in cnContacts {
            contact.fullName = cnContact.givenName + " " + cnContact.middleName + " " + cnContact.familyName
            
            if cnContact.imageDataAvailable {
                contact.profileImage = cnContact.imageData
            }
            
            // If we have a mobile phone number, use that by default. Otherwise, use whichever number is on top of the list.
            if let phone = cnContact.phoneNumbers.first(where: {$0.label == "$!<Mobile>!$_"}){
                contact.phoneNumberDigits = String(phone.value.stringValue.digits.suffix(10))
                contact.phoneNumber = phone.value.stringValue
            }
            else {
                contact.phoneNumberDigits = String(cnContact.phoneNumbers[0].value.stringValue.digits.suffix(10))
                contact.phoneNumber = cnContact.phoneNumbers[0].value.stringValue
            }
            
            
            phoneList.append(contact.phoneNumberDigits)
            contacts.append(contact)
        }
        
//        apiGateway.comparePhoneContactsToUsers(for: phoneList)
        
        return contacts
    }

//    mutating func comparePhoneContactsToUsers(for phoneList: Array<String>) {
//        let message = #"{ "phoneList": ["18018679309","(999) 888 7777","801-555-3333","+1 (666) 7779999","8013801913"]}"#
//        let request = RESTRequest(path: "/checknumbers", body: message.data(using: .utf8))
//        Amplify.API.post(request: request) { result in
//            switch result {
//            case .success(let data):
//                if let json = data.toJSON() {
//                    // try to read out a string array
//                    if let contactsInDatabase = json["contacts"] as? [[String:String]] {
//                        if contactsInDatabase != [] {
//                            for index in 0..<contacts.count {
//                                for contactInDatabase in contactsInDatabase {
//                                    if contacts[index].phoneNumberDigits == contactInDatabase["phone"] {
//                                        contacts[index].appUser = true
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    else {
//                        print("Couldn't parse the JSON file. Check the data type")
//                    }
//                }
//
//            case .failure(let apiError):
//                print("Failed", apiError)
//            }
//        }
//
//    }
    
}
