//
//  GeoLocator.swift
//  Geode
//
//  Created by John Watson on 1/19/16.
//
//  Copyright © 2016 Raizlabs. All rights reserved.
//  http://raizlabs.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import CoreLocation
import Foundation


/// A `GeoLocator` manages access to a `CLLocationManager` instance and acts as
/// its delegate.
open class GeoLocator: NSObject {

    /// A closure that is called with the device's most recent location.
    public typealias LocationUpdateHandler = (CLLocation) -> Void

    /// A closure that logs messages.
    public typealias LogHandler = (_ message: () -> String, _ level: LogLevel, _ file: StaticString, _ line: UInt) -> Void

    /**
     The `GeoLocator`'s mode of operation.

     - OneShot:    Update the device's location only when asked.
     - Continuous: Continuously monitor the device's location.
     */
    public enum MonitoringMode {
        case oneShot
        case continuous
    }

    /**
     The `GeoLocator`'s authorization status.

     - Unknown: It is unknown whether the user has granted access or not.
     - Yes:     The user has granted access to their location.
     - No:      The user has denied access to their location.
     */
    public enum AuthorizationStatus {
        case unknown
        case yes
        case no
    }

    /**
     Log levels used by the `GeoLocator`.

     - Error:   Error-level, possibly unrecoverable messages
     - Warning: Important messages
     - Info:    Informative messages
     - Debug:   Debug messages
     - Verbose: Everything
     */
    public enum LogLevel: Int {
        case error
        case warning
        case info
        case debug
        case verbose
    }

    /// Return the application's authorization status for location services.
    open class var authorizationStatus: AuthorizationStatus {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return .yes

        case .denied, .restricted:
            return .no

        case .notDetermined:
            return .unknown
        }
    }

    /// The location manager instance. Use this to customize location
    /// monitoring behavior.
    open let manager = CLLocationManager()

    /// The `GeoLocator`'s monitoring mode.
    open let mode: MonitoringMode

    /// The device's location from the most recent update.
    open fileprivate(set) var location: CLLocation

    /// The maximum age (in seconds) a location update may be before it is
    /// discarded. Defaults to 15 seconds.
    open var maxLocationAge = TimeInterval(15.0)

    /// Handler used to log framework messages.
    open var logHandler: LogHandler?

    /// Whether or not the `GeoLocator` is currently active.
    open var isActive: Bool {
        return active
    }

    fileprivate var updateHandler: LocationUpdateHandler?
    fileprivate var active = false
    fileprivate var waitingForAuthorization = false

    /**
     Initialize a `GeoLocator` instance with the given monitoring mode.

     - parameter mode: The monitoring mode to use.
     */
    public init(mode: MonitoringMode) {
        self.mode = mode

        // Start with an invalid location.
        location = CLLocation(
            latitude: kCLLocationCoordinate2DInvalid.latitude,
            longitude: kCLLocationCoordinate2DInvalid.longitude
        )

        super.init()

        manager.delegate = self
    }

}

// MARK: - Public

extension GeoLocator {

    /**
     Request a one-shot location update.

     - parameter handler: A closure that will be executed when the device's
                          location is updated.
     */
    public func requestLocationUpdate(_ handler: LocationUpdateHandler?) {
        guard mode == .oneShot else {
            handler?(location)
            return
        }

        let status = CLLocationManager.authorizationStatus()
        guard status != .restricted && status != .denied else {
            handler?(location)
            return
        }

        guard !active else {
            return
        }

        updateHandler = handler

        if GeoLocator.authorizationStatus == .yes {
            active = true
            manager.requestLocation()
        }
        else {
            waitingForAuthorization = true
            manager.requestWhenInUseAuthorization()
        }
    }

    /**
     Start continuously monitoring the device's location.

     - parameter handler: A closure that will be executed every time the
                          device's location updates.
     */
    public func startMonitoring(_ handler: LocationUpdateHandler?) {
        guard mode == .continuous else {
            handler?(location)
            return
        }

        let status = CLLocationManager.authorizationStatus()
        guard status != .restricted && status != .denied else {
            handler?(location)
            return
        }

        guard !active else {
            return
        }

        updateHandler = handler

        if GeoLocator.authorizationStatus == .yes {
            active = true
            manager.startUpdatingLocation()
        }
        else {
            waitingForAuthorization = true
            manager.requestWhenInUseAuthorization()
        }

    }

    /**
     Stop continously monitoring the device's location.
     */
    public func stopMonitoring() {
        if GeoLocator.authorizationStatus == .yes && mode == .continuous {
            manager.stopUpdatingLocation()
            updateHandler = nil
            active = false
        }
    }

}

// MARK: - Location Manager Delegate

extension GeoLocator: CLLocationManagerDelegate {

    // MARK: Responding to Location Events

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            assertionFailure("Must have at least one valid location!")
            return
        }

        log({ "location updated: \(newLocation.coordinate)" }, level: .verbose)

        let locationAge = abs(newLocation.timestamp.timeIntervalSinceNow)
        if mode == .continuous && locationAge > maxLocationAge || newLocation.horizontalAccuracy < 0.0 {
            log({ "ignoring old location" }, level: .info)
            return
        }

        location = newLocation

        switch mode {
        case .oneShot:
            updateHandler?(location)
            active = false
            updateHandler = nil

        case .continuous:
            updateHandler?(location)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let code = CLError.Code(rawValue: error._code), error._domain == kCLErrorDomain {
            switch code {
            case .locationUnknown:
                log({"Unknown location"}, level: .error)

            case .denied:
                log({"User has denied location access"}, level: .error)
                stopMonitoring()

            default:
                break
            }
        }

        if mode == .oneShot {
            updateHandler?(location)
            updateHandler = nil
            active = false
        }
    }

    // MARK: Responding to Authorization Changes

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        log({ "authorization status changed to \(status)"}, level: .verbose)

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            if waitingForAuthorization {
                waitingForAuthorization = false
                switch mode {
                case .oneShot:
                    requestLocationUpdate(updateHandler)

                case .continuous:
                    startMonitoring(updateHandler)
                }
            }

        case .restricted,
             .denied:
            if mode == .continuous {
                stopMonitoring()
            }

            location = CLLocation(
                latitude: kCLLocationCoordinate2DInvalid.latitude,
                longitude: kCLLocationCoordinate2DInvalid.longitude
            )

            if active || waitingForAuthorization {
                active = false
                waitingForAuthorization = false
                updateHandler?(location)
            }

        case .notDetermined:
            break
        }
    }

}

private extension GeoLocator {

    func log(_ message: () -> String, level: LogLevel, file: StaticString = #file, line: UInt = #line) {
        logHandler?(message, level, file, line)
    }

}
