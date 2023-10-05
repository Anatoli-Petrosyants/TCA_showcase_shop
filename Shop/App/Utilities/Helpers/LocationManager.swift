//
//  LocationManager.swift
//  Showcase
//
//  Created by Anatoli Petrosyants on 29.03.23.
//

// https://github.com/RajanMaheshwari/LocationManager/blob/master/LocationManager/LocationManager.swift

import CoreLocation

public protocol LocationManagerType: AnyObject {
    typealias LocationClosure = (_ location: CLLocation?, _ error: NSError?) -> Void
    
    func isLocationEnabled() -> Bool
    func getLocation(completionHandler: @escaping LocationClosure)
}

final class LocationManager: NSObject, LocationManagerType {
    
    enum LocationErrors: String {
        case denied = "Locations are turned off. Please turn it on in Settings"
        case restricted = "Locations are restricted"
        case notDetermined = "Locations are not determined yet"
        case notFetched = "Unable to fetch location"
        case unknown = "Some Unknown Error occurred"
    }
    
    private var locationCompletionHandler: LocationClosure?
    private var locationManager: CLLocationManager?
    private var lastLocation: CLLocation?
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    // MARK: LocationManagerType
    
    func isLocationEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
        
    func getLocation(completionHandler: @escaping LocationClosure) {
        lastLocation = nil
        locationCompletionHandler = completionHandler
        setupLocationManager()
    }
    
    // MARK: Private Methods
    
    private func setupLocationManager() {
        if locationManager != nil {
            check(status: locationManager?.authorizationStatus)
            return
        }
          
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        check(status: locationManager?.authorizationStatus)
    }
    
    private func check(status: CLAuthorizationStatus?) {
        guard let status = status else { return }
        switch status {
            
        case .authorizedWhenInUse,.authorizedAlways:
            locationManager?.startUpdatingLocation()
            
        case .denied:
            let deniedError = NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:[
                    NSLocalizedDescriptionKey: LocationErrors.denied.rawValue,
                    NSLocalizedFailureReasonErrorKey: LocationErrors.denied.rawValue,
                    NSLocalizedRecoverySuggestionErrorKey: LocationErrors.denied.rawValue
                ])
            
            didComplete(location: nil,error: deniedError)
            
        case .restricted:
            didComplete(location: nil, error: NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.restricted.rawValue),
                userInfo: nil))
            
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
            
        @unknown default:
            let unknownError = NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:[
                    NSLocalizedDescriptionKey: LocationErrors.unknown.rawValue,
                    NSLocalizedFailureReasonErrorKey: LocationErrors.unknown.rawValue,
                    NSLocalizedRecoverySuggestionErrorKey: LocationErrors.unknown.rawValue
                ])
            
            didComplete(location: nil, error: unknownError)
        }
    }
        
    private func didComplete(location: CLLocation?,error: NSError?) {
        locationManager?.stopUpdatingLocation()
        locationCompletionHandler?(location, error)
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    private func sendLocation() {
        guard let _ = lastLocation else {
            let notFetchedError = NSError(
                domain: self.classForCoder.description(),
                code:Int(CLAuthorizationStatus.denied.rawValue),
                userInfo:
                [NSLocalizedDescriptionKey: LocationErrors.notFetched.rawValue,
                 NSLocalizedFailureReasonErrorKey: LocationErrors.notFetched.rawValue,
                 NSLocalizedRecoverySuggestionErrorKey: LocationErrors.notFetched.rawValue])
            
            didComplete(location: nil, error: notFetchedError)
            lastLocation = nil
            return
        }

        didComplete(location: lastLocation,error: nil)
        lastLocation = nil
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {                
        lastLocation = locations.last
        guard let location = locations.last else { return }
        
        let locationAge = -(location.timestamp.timeIntervalSinceNow)
        
        if (locationAge > 5.0) {
            return
        }
        
        if location.horizontalAccuracy < 0 {
           self.locationManager?.stopUpdatingLocation()
           self.locationManager?.startUpdatingLocation()
           return
        }
        
        sendLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        check(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didComplete(location: nil, error: error as NSError?)
    }
}
