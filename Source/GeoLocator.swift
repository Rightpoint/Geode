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
public class GeoLocator: NSObject {

    /// A closure that is called with the device's most recent location.
    public typealias LocationUpdateHandler = (CLLocation) -> Void

    /// A closure that logs messages.
    public typealias LogHandler = (message: () -> String, level: LogLevel, file: StaticString, line: UInt) -> Void

    /**
     The `GeoLocator`'s mode of operation.

     - OneShot:    Update the device's location only when asked.
     - Continuous: Continuously monitor the device's location.
     */
    public enum MonitoringMode {
        case OneShot
        case Continuous
    }

    /**
     The `GeoLocator`'s authorization status.

     - Unknown: It is unknown whether the user has granted access or not.
     - Yes:     The user has granted access to their location.
     - No:      The user has denied access to their location.
     */
    public enum AuthorizationStatus {
        case Unknown
        case Yes
        case No
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
        case Error
        case Warning
        case Info
        case Debug
        case Verbose
    }

    /// Return the application's authorization status for location services.
    public class var authorizationStatus: AuthorizationStatus {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            return .Yes

        case .Denied, .Restricted:
            return .No

        case .NotDetermined:
            return .Unknown
        }
    }

    /// The location manager instance. Use this to customize location
    /// monitoring behavior.
    public let manager = CLLocationManager()

    /// The `GeoLocator`'s monitoring mode.
    public let mode: MonitoringMode

    /// The device's location from the most recent update.
    public private(set) var location: CLLocation

    /// The maximum age (in seconds) a location update may be before it is
    /// discarded. Defaults to 15 seconds.
    public var maxLocationAge = NSTimeInterval(15.0)

    /// Handler used to log framework messages.
    public var logHandler: LogHandler?

    private var updateHandler: LocationUpdateHandler?
    private var active = false

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
    public func requestLocationUpdate(handler: LocationUpdateHandler?) {
        if GeoLocator.authorizationStatus == .Yes && mode == .OneShot {
            updateHandler = handler
            manager.requestLocation()
        }
        else {
            handler?(location)
        }
    }

    /**
     Start continuously monitoring the device's location.

     - parameter handler: A closure that will be executed every time the
                          device's location updates.
     */
    public func startMonitoring(handler: LocationUpdateHandler?) {
        if GeoLocator.authorizationStatus == .Yes && mode == .Continuous {
            updateHandler = handler
            manager.startUpdatingLocation()
            active = true
        }
    }

    /**
     Stop continously monitoring the device's location.
     */
    public func stopMonitoring() {
        if GeoLocator.authorizationStatus == .Yes && mode == .Continuous {
            manager.stopUpdatingLocation()
            updateHandler = nil
            active = false
        }
    }

}

// MARK: - Location Manager Delegate

extension GeoLocator: CLLocationManagerDelegate {

    // MARK: Responding to Location Events

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            assertionFailure("Must have at least one valid location!")
            return
        }

        log({ "location updated: \(newLocation.coordinate)" }, level: .Verbose)

        let locationAge = abs(newLocation.timestamp.timeIntervalSinceNow)
        if locationAge > maxLocationAge || newLocation.horizontalAccuracy < 0.0 {
            log({ "ignoring old location" }, level: .Info)
            return
        }

        location = newLocation

        switch mode {
        case .OneShot:
            updateHandler?(location)
            updateHandler = nil

        case .Continuous:
            updateHandler?(location)
        }
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if let code = CLError(rawValue: error.code) where error.domain == kCLErrorDomain {
            switch code {
            case .LocationUnknown:
                log({"Unknown location"}, level: .Error)

            case .Denied:
                log({"User has denied location access"}, level: .Error)
                stopMonitoring()

            default:
                break
            }
        }
    }

    // MARK: Responding to Authorization Changes

    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        log({ "authorization status changed to \(status)"}, level: .Verbose)

        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            if active {
                switch mode {
                case .OneShot:
                    requestLocationUpdate(updateHandler)

                case .Continuous:
                    startMonitoring(updateHandler)
                }
            }

        case .Restricted,
             .Denied:
            if mode == .Continuous {
                stopMonitoring()
            }

            location = CLLocation(
                latitude: kCLLocationCoordinate2DInvalid.latitude,
                longitude: kCLLocationCoordinate2DInvalid.longitude
            )

        case .NotDetermined:
            break
        }
    }

}

private extension GeoLocator {

    func log(message: () -> String, level: LogLevel, file: StaticString = __FILE__, line: UInt = __LINE__) {
        logHandler?(message: message, level: level, file: file, line: line)
    }

}
