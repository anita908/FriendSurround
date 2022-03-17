//
//  User.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 1/10/22.
//

import Foundation
import CoreLocation
import Amplify
import UserNotifications

class UserData: Identifiable {
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phone :String = ""
    var email: String = ""
    var userLocation: String = ""
    var pendingFriendRequestsIn: Array<String> = []
    var pendingFriendRequestsOut: Array<String> = []
    var friends: Array<[String:String]> = []
    var createdDate: String = ""
    var deletedDate: String = ""
    var deleted: Bool = false
    var blockedPeople: Array<[String:String]> = []
    
    var nearbyFriends: Array<[String:String]> {
        var closeFriends: Array<[String:String]> = []
        if let loc = convertLocation(from: userLocation) {
            for friend in self.friends {
                
                if let friendLoc = convertLocation(from: friend["userLocation"] ?? "") {
                    let distance = loc.distance(from: friendLoc)
                    if distance < 100 {
                        closeFriends.append(friend)
                    }
                }
            }
        }
        print(closeFriends.count)
         if closeFriends.count == 1 {
             scheduleNotification(closeFriends[0]["firstName"]!, 1)
         }
         if closeFriends.count > 1 {
             scheduleNotification("", closeFriends.count)
         }
        
        return closeFriends
    }
    
    static let shared = UserData()
    init() {}
    
    
    func convertLocation(from locationString: String) -> CLLocation? {
        let pattern = "(^[0-9.-]+,[0-9.-]+$)"
        if (locationString.range(of: pattern, options:.regularExpression) != nil) {
            
            let locationNoSpaces = String(locationString.filter { !" \n\t\r".contains($0) })
            let coordinates = locationNoSpaces.components(separatedBy: ",")
            let updatedUserLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
            return updatedUserLocation
        }
        else {
            print("Location Data is not formatted correctly")
            return nil
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(_ name: String, _ number: Int) {
        requestNotificationPermission()
        let notificationID: String = UUID().uuidString
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Friend Surround"
        if number == 1 {
            content.subtitle = "\(name) is close!"
        } else {
            content.subtitle = "You have \(number) friends nearby!"
        }
        
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
