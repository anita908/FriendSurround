//
//  ApiGateway.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/22/22.
//

import Foundation
import Amplify

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

//Assuming the data will come in like so: {"phones": "[8019998888,8013338888,8673330000]"}
func comparePhoneContactsToUsers() {
    let message = #"{"phones": "[8019998888,8013338888,8673330000]"}"#
    let request = RESTRequest(path: "/phoneContacts", body: message.data(using: .utf8))
    Amplify.API.post(request: request) { result in
        switch result {
        case .success(let data):
            
            if let json = data.toJSON() {
                // try to read out a string array
                if let friends = json["friends"] as? [[String:Any]] {
                    for friend in friends {
                        print(friend["username"] as? String ?? "")
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
