//
//  AddWeatherViewModel.swift
//  WeatherApp
//
//  Created by Veerababu Mulugu on 29/05/23.
//

import CoreLocation
import Foundation

class LocationViewModel: NSObject {
    // MARK: - Properties -

    /// Private Properties

    private let locationManager = CLLocationManager()

    /// Public Properties

    let defaultCity = NSLocalizedString("New York", comment: "")
    var currentLocation = CLLocation(latitude: 40.7128, longitude: 74.0060)
    var onlocationRetrive: ((CLLocation) -> Void)?
    var onError: ((String, String) -> Void)?

    /// locationmanager setup for start updating location

    func setupLocationManager() {
        DispatchQueue.global().async {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            self.locationManager.delegate = self
        }
    }
}

// MARK: - CLLocationManagerDelegate -

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        onlocationRetrive?(location)
        locationManager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                self.onError?(NSLocalizedString("info".capitalized, comment: ""), NSLocalizedString("Your location is set to default(New York)", comment: ""))
                self.onlocationRetrive?(self.currentLocation)
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        }
        }
    }
}
