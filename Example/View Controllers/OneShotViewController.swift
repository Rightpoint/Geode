//
//  OneShotViewController.swift
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


final class OneShotViewController: UIViewController {

    private var locator = Geode.GeoLocator(mode: .OneShot)
    private var stackView = UIStackView()
    private var navBarExtension = NavBarExtension()
    private var mapView = MKMapView()

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

        navigationItem.title = "One-Shot"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Refresh,
            target: self,
            action: "refreshAction"
        )

        // Accept all location values.
        locator.maxLocationAge = DBL_MAX
        locator.manager.requestWhenInUseAuthorization()

        mapView.showsUserLocation = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        refreshLocation()
    }

}

// MARK: - Actions

extension OneShotViewController {

    /**
     Refresh the user's current location.
     */
    func refreshAction() {
        refreshLocation()
    }

}

// MARK: - Map View Delegate

extension OneShotViewController: MKMapViewDelegate {

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?

        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(LocationAnnotationView.reuseIdentifier) {
            annotationView.annotation = annotation
        }
        else {
            annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: LocationAnnotationView.reuseIdentifier)
        }

        return annotationView
    }

}

// MARK: - Private

private extension OneShotViewController {

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

    func refreshLocation() {
        locator.requestLocationUpdate { [weak self] location in
            if let location = location {
                self?.mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0), animated: true)
                self?.navBarExtension.coordinate = location.coordinate
                self?.addAnnotation(forLocation: location)
            }
        }
    }

    func addAnnotation(forLocation location: CLLocation) {
        mapView.removeAnnotations(mapView.annotations)

        let annotation = LocationAnnotation(location: location)
        mapView.addAnnotation(annotation)
    }

}
