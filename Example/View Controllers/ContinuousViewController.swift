//
//  ContinuousViewController.swift
//  Example
//
//  Created by John Watson on 2/2/16.
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

import Geode
import MapKit
import UIKit

final class ContinuousViewontroller: LocationViewController {

    fileprivate var locator = Geode.GeoLocator(mode: .continuous)
    fileprivate var annotation = LocationAnnotation()
    fileprivate var lastCoordinate = kCLLocationCoordinate2DInvalid

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Continuous"

        // Accept all location values.
        locator.maxLocationAge = DBL_MAX
        locator.manager.requestWhenInUseAuthorization()
        locator.logHandler = type(of: self).logHandler

        locator.startMonitoring { [weak self] location in
            self?.updateLocation(location)
        }
    }

}

private extension ContinuousViewontroller {

    func updateLocation(_ location: CLLocation) {
        // If the updated coordinate is the same as the previous one, avoid
        // further processing.
        if location.coordinate == lastCoordinate {
            return
        }

        // Save the previous coordinate.
        lastCoordinate = annotation.coordinate

        // Update the annotation and nav bar with the latest coordinate.
        annotation.coordinate = location.coordinate
        navBarExtension.coordinate = location.coordinate

        if annotation.coordinate.isInvalid {
            mapView.removeAnnotation(annotation)
        }
        else {
            mapView.addAnnotation(annotation)
            assert(mapView.annotations.count == 1, "Too many annotations present!")

            mapView.setRegion(MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000.0, 1000.0), animated: true)
        }
    }

}
