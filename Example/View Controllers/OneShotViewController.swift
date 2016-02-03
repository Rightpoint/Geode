//
//  OneShotViewController.swift
//  Example
//
//  Created by John Watson on 2/1/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Geode
import MapKit
import UIKit


final class OneShotViewController: LocationViewController {

    private var locator = Geode.GeoLocator(mode: .OneShot)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "One-Shot"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Refresh,
            target: self,
            action: "refreshAction"
        )

        // Accept all location values.
        locator.maxLocationAge = DBL_MAX
        locator.manager.requestWhenInUseAuthorization()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

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

// MARK: - Private

private extension OneShotViewController {

    func refreshLocation() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
        spinner.startAnimating()

        let refreshItem = navigationItem.rightBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)

        locator.requestLocationUpdate { [weak self] location in
            if location.coordinate == kCLLocationCoordinate2DInvalid {
                self?.mapView.removeAnnotations(self?.mapView.annotations ?? [])
            }
            else {
                self?.mapView.setRegion(MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0, 1000.0), animated: true)
                self?.addAnnotation(forLocation: location)
            }

            spinner.stopAnimating()
            self?.navBarExtension.coordinate = location.coordinate
            self?.navigationItem.rightBarButtonItem = refreshItem
        }
    }

}
