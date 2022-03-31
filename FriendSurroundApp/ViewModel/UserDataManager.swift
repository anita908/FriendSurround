//
//  UserDataManager.swift
//  FriendSurroundApp
//
//  Created by Desmond Jeffery on 2/23/22.
//

import Foundation

final class UserDataManager: ObservableObject {
    
    var locationService = LocationService.shared
    var apiGateway = ApiGateway()
    
    var userData: UserData {
        UserData.shared
    }
    
    func updateLocation() {
        let currentLocation = self.locationService.currentLocation
        
        //Get most recent user data
        self.apiGateway.updateLocation(for: self.locationService.currentUser, at: "\(currentLocation.latitude),\(currentLocation.longitude)", completionHandler: {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        })
    }
    
}
