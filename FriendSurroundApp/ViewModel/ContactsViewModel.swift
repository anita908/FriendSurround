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
        
        //Disclude the user from the list
        let contactsWithoutUser = ContactsApp.shared.contacts.filter({$0.username != UserData.shared.username})
        
        let sortedContacts = contactsWithoutUser.sorted{
            
            if $0.friendshipStatus != $1.friendshipStatus { // first, compare by last names
                    return $0.friendshipStatus < $1.friendshipStatus
                }
                /*  last names are the same, break ties by foo
                else if $0.foo != $1.foo {
                    return $0.foo < $1.foo
                }
                ... repeat for all other fields in the sorting
                */
                else { // All other fields are tied, break ties by last name
                    return $0.fullName < $1.fullName
                }
            }
        
        return sortedContacts
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
            
            //Get most recent friendship status of each contact
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
        apiGateway.acceptFriendRequest(from: username, to: friendUsername, completionHandler: {
            DispatchQueue.main.async {
                self.updateContacts()
            }
        })
    }
    
    func getFriend(from username: String) -> UserData.Friend{
        for friend in UserData.shared.friends {
            if friend.username == username {
                return friend
            }
        }
        return UserData.Friend()
    }
    
}

extension Sequence {
  func sorted(
    by firstPredicate: (Element, Element) -> Bool,
    _ secondPredicate: (Element, Element) -> Bool,
    _ otherPredicates: ((Element, Element) -> Bool)...
  ) -> [Element] {
    return sorted(by:) { lhs, rhs in
      if firstPredicate(lhs, rhs) { return true }
      if firstPredicate(rhs, lhs) { return false }
      if secondPredicate(lhs, rhs) { return true }
      if secondPredicate(rhs, lhs) { return false }
      for predicate in otherPredicates {
        if predicate(lhs, rhs) { return true }
        if predicate(rhs, lhs) { return false }
      }
      return false
    }
  }
}
