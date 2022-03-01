//
//  LocationService.swift
//  FriendSurroundApp
//
//  Created by Christopher McLeod on 2/23/22.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var currentUser: String = ""
    
    var apiGateway = ApiGateway()

    private override init() {
        super.init()
    }
    static let shared = LocationService()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 100
        manager.allowsBackgroundLocationUpdates = true
        manager.delegate = self
        return manager
    }()

    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            // The app will only get their location when they have the app open
            // Wake up app to run in the background
            // Link them to settings to click on always allow
            print("Authorized When In Use")
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            // The app cannot get location if they completely close out of it
            print("Always Authorized")
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("Restricted or Denied")
        default:
            print("Location Service Denied")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .authorizedWhenInUse, .authorizedAlways:
            requestLocationUpdates()
        default:
            print("Changed to Non Authorized")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
//        print(location)
        if location.speed < 0.85 {
            print(location)
            print(currentUser)
            currentLocation = location.coordinate
            apiGateway.updateLocation(for: currentUser, at: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
