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

class ContactsManager: ObservableObject {

    var apiGateway = ApiGateway()
    var locationService = LocationService.shared
    
    //MARK: Accessing the model
    
    var contacts: [ContactsApp.Contact] {
        ContactsApp.shared.contacts
    }
    
    func updateContacts(){

        //Get most recent contacts
        let currentLocation = self.locationService.currentLocation
        ContactsApp.shared.updateContacts()
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        //Get most recent user data
        self.apiGateway.updateLocation(for: self.locationService.currentUser, at: "\(currentLocation.latitude),\(currentLocation.longitude)", completionHandler: {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
            //Get most friendship status of each contact
            self.apiGateway.findAppUsers(for: ContactsApp.shared.contacts, completionHandler: {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
                
            })
        })
        
    }
    
    func sendFriendRequest(from username: String, to friendUsername: String){
        
        apiGateway.sendFriendRequest(from: username, to: friendUsername, completionHandler: {
            self.updateContacts()
        })
        

    }
    
    func massFriendRequst(from username: String, for contacts: Array<ContactsApp.Contact>){
        for contact in contacts {
            if contact.friendshipStatus == .notFriends{
                print("not friends")
                sendFriendRequest(from: username, to: contact.username ?? "")
            }
        }
    }
    
    func acceptFriendRequest(from username: String, to friendUsername: String){
        apiGateway.acceptFriendRequest(from: username, to: friendUsername)
        objectWillChange.send()
    }
    
    
}
