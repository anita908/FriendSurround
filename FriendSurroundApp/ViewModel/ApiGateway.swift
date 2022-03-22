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

    //Assuming the data will come in like so: {"phones": "[8019998888,8013338888,8673330000]"}
    func comparePhoneContactsToUsers(for phoneList: Array<String>, completionHandler: @escaping ([[String:String]]) -> ()) {
        let message = #"{ "phoneList": ["18018679309","(999) 888 7777","801-555-3333","+1 (666) 7779999","8013801913"]}"#
        let request = RESTRequest(path: "/checknumbers", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                if let json = data.toJSON() {
                    // try to read out a string array
                    if let contactsInDatabase = json["contacts"] as? [[String:String]] {
                        completionHandler(contactsInDatabase)
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
    func updatePersonalDetail(_ phone: String, _ firstName: String, _ lastName: String, _ email: String) {
        print("updatePersonalDetail")
        var inputPhone = phone
        var inputFirstName = firstName
        var inputLastName = lastName
        var inputEmail = email
        
        if phone == "" {
            inputPhone = userData.phone
        }
        if firstName == "" {
            inputFirstName = userData.firstName
        }
        if lastName == "" {
            inputLastName = userData.lastName
        }
        if email == "" {
            inputEmail = userData.email
        }
   
        
        print(inputPhone)
        print(inputFirstName)
        print(inputLastName)
        print(inputEmail)
        
        let message = #"{"username": "mickey","firstName": "\#(inputFirstName)","lastName": "\#(inputLastName)","email": "\#(inputEmail)","phone": "\#(inputPhone)"}"#
        let request = RESTRequest(path: "/updateuserdetails", body: message.data(using: .utf8))
        Amplify.API.post(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
                self.userData.phone = phone
                self.userData.firstName = firstName
                self.userData.lastName = lastName
                self.userData.email = email
                
            case .failure(let apiError):
                print("Failed", apiError)
            }
        }
    }
}
