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
    var friends: [Friend] = []
    var potentialFriends: [PotentialFriend] = []
    var createdDate: String = ""
    var deletedDate: String = ""
    var deleted: Bool = false
    var blockedPeople: Array<[String:String]> = []
    var profileImage: Data? = nil
    var delegate = NotificationDelelegate()
    private var previousNearbyFriends: [Friend] = []
    
    var nearbyFriends: [Friend] {
        print("previous nearby frirn")
        print(previousNearbyFriends)
        var newCloseFriends: [Friend] = []
        var closeFriends: [Friend] = []
        if let loc = convertLocation(from: userLocation) {
            for friend in self.friends {
                
                if let friendLoc = convertLocation(from: friend.userLocation ) {
                    let distance = loc.distance(from: friendLoc)
                    print("\(friend.firstName) is \(distance)  meters away")
                    if distance < 10 {
                        closeFriends.append(friend)
                    }
                }
            }
        }
        for friend in closeFriends {
            if !previousNearbyFriends.contains(where: { $0.username == friend.username}){
                print("appended")
                newCloseFriends.append(friend)
            }
        }
//        print("")
//        print("close")
//        print(closeFriends)
//        print("new close")
//        print(newCloseFriends)
        if newCloseFriends.count == 1 {
            scheduleNotification(newCloseFriends[0].firstName, 1)
            UNUserNotificationCenter.current().delegate = delegate
        }
        if newCloseFriends.count > 1 {
            scheduleNotification("", closeFriends.count)
            UNUserNotificationCenter.current().delegate = delegate
        }
        previousNearbyFriends = closeFriends
        
        return closeFriends
    }
    
    struct Friend: Hashable, Identifiable {
        
        var id = UUID()
        
        var username: String = ""
        
        var firstName: String = ""
        
        var lastName: String = ""
        
        var userLocation: String = ""
        
        var email: String = ""
        
        var phone: String = ""
        
        var profileImage: Data? = nil
        
        var isContact: Bool = false
    }
    
    struct PotentialFriend: Hashable, Identifiable {
        var id = UUID()
        
        var username: String = ""
        
        var friendshipStatus: ContactsApp.FriendshipStatus = .notAnAppUser
        
        init(username: String, friendshipStatus: ContactsApp.FriendshipStatus){
            self.username = username
            self.friendshipStatus = friendshipStatus
        }
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
            content.subtitle = "You have \(number) new friends nearby!"
        }
        
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
}

class NotificationDelelegate: NSObject,ObservableObject,UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge,.banner,.sound])
    }
}
