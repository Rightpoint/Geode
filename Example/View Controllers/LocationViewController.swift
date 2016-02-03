//
//  LocationViewController.swift
//  Geode
//
//  Created by John Watson on 1/28/16.
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


class LocationViewController: UIViewController {

    /// Simple log handler that subclasses can use with their `GeoLocator` instance.
    static let logHandler: Geode.GeoLocator.LogHandler = { message, level, file, line in
        debugPrint("[GEODE] \(String(level).uppercaseString) \(file) L\(line): \(message())")
    }

    let navBarExtension = NavBarExtension()
    let mapView = MKMapView()

    private let stackView = UIStackView()

    override func loadView() {
        edgesForExtendedLayout = .None

        view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.whiteColor()

        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .EqualSpacing

        mapView.delegate = self

        view.addSubview(stackView)
        stackView.addArrangedSubview(navBarExtension)
        stackView.addArrangedSubview(mapView)

        configureConstraints()
    }

    override func viewDidLoad() {
        // Hide the nav bar's hairline so that the extension view appears flush
        // beneath it.
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}

// MARK: - Map View Delegate

extension LocationViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?

        if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(LocationAnnotationView.reuseIdentifier) {
            view.annotation = annotation
            annotationView = view
        }
        else {
            annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: LocationAnnotationView.reuseIdentifier)
        }

        assert(annotationView != nil)
        return annotationView
    }

}

// MARK: - Protected

extension LocationViewController {

    func configureConstraints() {
        // The stack view fills the width and height of the view.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        stackView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true

        // The nav bar extension fills the width of the stack view and has a
        // fixed height.
        navBarExtension.translatesAutoresizingMaskIntoConstraints = false
        navBarExtension.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor).active = true
        navBarExtension.heightAnchor.constraintEqualToConstant(44.0).active = true

        // The map view fills the width of the stack view and the remainder
        // of its height.
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraintEqualToAnchor(navBarExtension.bottomAnchor).active = true
        mapView.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor).active = true
    }

    func addAnnotation(forLocation location: CLLocation) {
        mapView.removeAnnotations(mapView.annotations)

        let annotation = LocationAnnotation(coordinate: location.coordinate)
        mapView.addAnnotation(annotation)
    }

}
