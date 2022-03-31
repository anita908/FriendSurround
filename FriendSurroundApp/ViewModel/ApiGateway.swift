//
//  ApiGateway.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/22/22.
//

import Foundation
import Amplify

final class ApiGateway: ObservableObject {

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
                        UserData.shared.username = newUserData["username"] as? String ?? ""
                        UserData.shared.firstName = newUserData["firstName"] as? String ?? ""
                        UserData.shared.lastName = newUserData["lastName"] as? String ?? ""
                        UserData.shared.phone = newUserData["phone"] as? String ?? ""
                        UserData.shared.email = newUserData["email"] as? String ?? ""
                        UserData.shared.userLocation = newUserData["userLocation"] as? String ?? ""
                        UserData.shared.pendingFriendRequestsIn = newUserData["pendingFriendRequestsIn"] as? Array<String> ?? [""]
                        UserData.shared.pendingFriendRequestsOut = newUserData["pendingFriendRequestsOut"] as? Array<String> ?? [""]
                        UserData.shared.friends = self.loadFriendsArray(from: newUserData["friends"] as? Array<[String:String]> ?? [["":""]])
                        UserData.shared.profileImage = self.addProfilePictureToUser(with: newUserData["phone"] as? String ?? "")
                        UserData.shared.createdDate = newUserData["createdDate"] as? String ?? ""
                        UserData.shared.deletedDate = newUserData["deletedDate"] as? String ?? ""
                        UserData.shared.deleted = newUserData["deleted"] as? Bool ?? false
                        UserData.shared.blockedPeople = newUserData["blockedPeople"] as? Array<[String:String]> ?? [["":""]]
                        UserData.shared.updateNearbyFriends(previousNearbyFriends: UserData.shared.nearbyFriends)
                        self.findAppUsers(for: ContactsApp.shared.contacts, completionHandler: {
                            self.setPotentialFriends(requestsIn: newUserData["pendingFriendRequestsIn"] as? Array<String> ?? [""])
                            completionHandler()
                        })
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
    
    func setPotentialFriends(requestsIn: Array<String>){
        UserData.shared.potentialFriends = []
        for username in requestsIn {
            if !UserData.shared.potentialFriends.contains(where: {$0.username == username}) && !ContactsApp.shared.contacts.contains(where: {$0.username == username})
            {
                UserData.shared.potentialFriends.append(UserData.PotentialFriend(username: username, friendshipStatus: .requestReceived))
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
        ContactsApp.shared.updateContacts()
        for contact in ContactsApp.shared.contacts {
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
        for friend in UserData.shared.friends{
            if contact.username == friend.username {
                ContactsApp.shared.contacts[index].friendshipStatus = .friends
                return
            }
        }
        
        for requestInUsername in UserData.shared.pendingFriendRequestsIn{
            if contact.username == requestInUsername {
                ContactsApp.shared.contacts[index].friendshipStatus = .requestReceived
                return
            }
        }
        
        for requestOutUsername in UserData.shared.pendingFriendRequestsOut {
            if contact.username == requestOutUsername {
                ContactsApp.shared.contacts[index].friendshipStatus = .requestSent
                return
            }
        }
        
        ContactsApp.shared.contacts[index].friendshipStatus = .notFriends
    }
    
    func findAppUsers(for contacts: Array<ContactsApp.Contact>, completionHandler: @escaping () -> ()) {
        let phoneList = createPhoneList(from: contacts)
        let message = #"{ "phoneList": \#(phoneList)}"#
        let request = RESTRequest(path: "/checknumbers", body: message.data(using: .utf8))
        let contacts = ContactsApp.shared.contacts
        
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
                                        ContactsApp.shared.contacts[index].username = contactInDatabase["username"]
                                        self.updateFriendshipStatus(for: ContactsApp.shared.contacts[index], with: index)
                                        
                                        
                                    }
                                }
                            }
                        }
                        completionHandler()
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
    
    func acceptFriendRequest(from username: String, to friendUsername: String, completionHandler: @escaping () -> ()){
        let message = #"{"username": "\#(username)", "friendUsername": "\#(friendUsername)"}"#
        let request = RESTRequest(path: "/acceptfriendrequest", body: message.data(using: .utf8))
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
    
    func updatePersonalDetail(_ username: String, _ phone: String, _ firstName: String, _ lastName: String, _ email: String) {
        print("updatePersonalDetail")
        var inputPhone = phone
        var inputFirstName = firstName
        var inputLastName = lastName
        var inputEmail = email

        if phone == "" {
            inputPhone = UserData.shared.phone
        }
        if firstName == "" {
            inputFirstName = UserData.shared.firstName
        }
        if lastName == "" {
            inputLastName = UserData.shared.lastName
        }
        if email == "" {
            inputEmail = UserData.shared.email
        }


//        print(inputPhone)
//        print(inputFirstName)
//        print(inputLastName)
//        print(inputEmail)

        let message = #"{"username": "\#(username)","firstName": "\#(inputFirstName)","lastName": "\#(inputLastName)","email": "\#(inputEmail)","phone": "\#(inputPhone)"}"#
        let request = RESTRequest(path: "/updateuserdetails", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
                UserData.shared.phone = phone
                UserData.shared.firstName = firstName
                UserData.shared.lastName = lastName
                UserData.shared.email = email

            case .failure(let apiError):
                print("Failed", apiError)
            }
        }
    }
}
