//
//  notification.swift
//  FriendSurroundApp
//
//  Created by 吳若瑀 on 2/1/22.
//

import SwiftUI
import UserNotifications

struct notification: View {
    @State private var notificationID: String = UUID().uuidString
    var body: some View {
        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            .padding()

            Button("Schedule Notification") {
                let content = UNMutableNotificationContent()
                content.title = "Friend Surround"
                content.subtitle = "Anita is close"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request)
            }
            .padding()
            
            Button("Update Notification") {
                let content = UNMutableNotificationContent()
                content.title = "Friend Surround"
                content.subtitle = "2 friends is around you!"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request)
            }
            .padding()
            
            Button("Remove Notification") {
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }
            .padding()

        }

    }
}

struct notification_Previews: PreviewProvider {
    static var previews: some View {
        notification()
    }
}
