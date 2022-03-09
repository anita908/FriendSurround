//
//  ApiGateway.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/22/22.
//

import Foundation
import Amplify

final class ApiGateway: ObservableObject {
    
    var userData = UserData.shared
    var contactsApp = ContactsApp.shared

    func examplePostRequest() {
        let message = #"{"username": "nesdom13"}"#
        let request = RESTRequest(path: "/location", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
            case .failure(let apiError):
                print("Failed", apiError)
            }
        }
    }

    func exampleGetRequest() {
        let request = RESTRequest(path: "/todo")
        Amplify.API.get(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
            case .failure(let apiError):
                print("Failed", apiError)
            }
        }
    }

    func updateLocation(for username: String, at newLocation: String) {
        let message = #"{"username": "\#(username)", "newLocation": "\#(newLocation)"}"#
        print(message)
        let request = RESTRequest(path: "/location", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                if let json = data.toJSON() {
                    if let newUserData = json["userData"] as? [String:Any] {
                        self.userData.username = newUserData["username"] as? String ?? ""
                        self.userData.firstName = newUserData["firstName"] as? String ?? ""
                        self.userData.lastName = newUserData["lastName"] as? String ?? ""
                        self.userData.phone = newUserData["phone"] as? String ?? ""
                        self.userData.email = newUserData["email"] as? String ?? ""
                        self.userData.userLocation = newUserData["userLocation"] as? String ?? ""
                        self.userData.pendingFriendRequestsIn = newUserData["pendingFriendRequestsIn"] as? Array<String> ?? [""]
                        self.userData.pendingFriendRequestsOut = newUserData["pendingFriendRequestsOut"] as? Array<String> ?? [""]
                        self.userData.friends = newUserData["friends"] as? Array<[String:String]> ?? [["":""]]
                        self.userData.createdDate = newUserData["createdDate"] as? String ?? ""
                        self.userData.deletedDate = newUserData["deletedDate"] as? String ?? ""
                        self.userData.deleted = newUserData["deleted"] as? Bool ?? false
                        self.userData.blockedPeople = newUserData["blockedPeople"] as? Array<[String:String]> ?? [["":""]]
                        }
                        else {
                            print("Couldn't parse the JSON file. Check the data type")
                        }
                    }
                    else {
                        print("Couldn't parse the JSON file. Check the data type")
                    }
                
                case .failure(let apiError):
                    print("Failed", apiError)
                }
            }
                
    }
    
    func createPhoneList(from contacts: Array<ContactsApp.Contact>) -> [String] {
        var phoneList: [String] = []
        for contact in contacts {
            phoneList.append(contact.phoneNumberDigits)
        }
        return phoneList
    }
    
   //Assuming the data will come in like so: {"phones": "[8019998888,8013338888,8673330000]"}
    func findAppUsers(for contacts: Array<ContactsApp.Contact>) {
        let phoneList = createPhoneList(from: contacts)
        
        let message = #"{ "phoneList": \#(phoneList)}"#
        let request = RESTRequest(path: "/checknumbers", body: message.data(using: .utf8))
        let contacts = contactsApp.contacts
        
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
                                        self.contactsApp.contacts[index].appUser = true
                                    }
                                }
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
