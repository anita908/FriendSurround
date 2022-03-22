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

    func updateLocation(for username: String, at newLocation: String, completionHandler: @escaping () -> ()) {
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
                        self.userData.friends = self.loadFriendsArray(from: newUserData["friends"] as? Array<[String:String]> ?? [["":""]])
                        self.userData.profileImage = self.addProfilePictureToUser(with: newUserData["phone"] as? String ?? "")
                        self.userData.createdDate = newUserData["createdDate"] as? String ?? ""
                        self.userData.deletedDate = newUserData["deletedDate"] as? String ?? ""
                        self.userData.deleted = newUserData["deleted"] as? Bool ?? false
                        self.userData.blockedPeople = newUserData["blockedPeople"] as? Array<[String:String]> ?? [["":""]]
                        print(self.userData.nearbyFriends)
                        completionHandler()
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
    
    func loadFriendsArray(from friends: Array<[String:String]>) -> [UserData.Friend]{
        var friendsArray: [UserData.Friend] = []
        for friend in friends {
            var newFriend = UserData.Friend()
            newFriend.username = friend["username"] ?? ""
            newFriend.firstName = friend["firstName"] ?? ""
            newFriend.lastName = friend["lastName"] ?? ""
            newFriend.userLocation = friend["userLocation"] ?? ""
            newFriend.email = friend["email"] ?? ""
            newFriend.phone = friend["phone"] ?? ""
            newFriend.profileImage = addProfilePictureToUser(with: friend["phone"] ?? "")
            
            friendsArray.append(newFriend)
        }
        return friendsArray
    }
    
    func addProfilePictureToUser(with phone: String) -> Data?{
        for contact in contactsApp.contacts {
            if contact.phoneNumberDigits == phone {
                return contact.profileImage
            }
        }
        return nil
    }
    
    func createPhoneList(from contacts: Array<ContactsApp.Contact>) -> [String] {
        var phoneList: [String] = []
        for contact in contacts {
            phoneList.append(contact.phoneNumberDigits ?? "")
        }
        return phoneList
    }
    
    func updateFriendshipStatus(for contact: ContactsApp.Contact, with index: Int){
        for friend in userData.friends{
            if let friendUsername = friend.username{
                if contact.username == friendUsername {
                    self.contactsApp.contacts[index].friendshipStatus = .friends
                    return
                }
            }
        }
        
        for requestInUsername in userData.pendingFriendRequestsIn{
            if contact.username == requestInUsername {
                self.contactsApp.contacts[index].friendshipStatus = .requestReceived
                return
            }
        }
        
        for requestOutUsername in userData.pendingFriendRequestsOut {
            if contact.username == requestOutUsername {
                self.contactsApp.contacts[index].friendshipStatus = .requestSent
                return
            }
        }
        
        self.contactsApp.contacts[index].friendshipStatus = .notFriends
    }
    
    func findAppUsers(for contacts: Array<ContactsApp.Contact>, completionHandler: @escaping () -> ()) {
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
                                        self.contactsApp.contacts[index].username = contactInDatabase["username"]
                                        self.updateFriendshipStatus(for: self.contactsApp.contacts[index], with: index)
                                        
                                        
                                    }
                                }
                            }
                            completionHandler()
                            
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
    
    func sendFriendRequest(from username: String, to friendUsername: String, completionHandler: @escaping () -> ()){
        let message = #"{"username": "\#(username)", "friendUsername": "\#(friendUsername)"}"#
        let request = RESTRequest(path: "/sendfriendrequest", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
                completionHandler()
            case .failure(let apiError):
                print("Failed", apiError)
            
                
            }
        }
    }
    
    func acceptFriendRequest(from username: String, to friendUsername: String){
        let message = #"{"username": "\#(username)", "friendUsername": "\#(friendUsername)"}"#
        let request = RESTRequest(path: "/acceptfriendrequest", body: message.data(using: .utf8))
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

    
}
