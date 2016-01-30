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
    private var mapView = MKMapView()
    private var navBarExtension = UIView()

    override func loadView() {
        edgesForExtendedLayout = .None

        view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.whiteColor()

        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .EqualSpacing

        view.addSubview(stackView)
        stackView.addArrangedSubview(navBarExtension)
        stackView.addArrangedSubview(mapView)

        configureConstraints()
    }

    override func viewDidLoad() {
        navigationItem.title = "One-Shot"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Refresh,
            target: self,
            action: "refreshAction"
        )
    }

}

// MARK: - Actions

extension OneShotViewController {

    /**
     Refresh the user's current location.
     */
    func refreshAction() {
    }

}

// MARK: - Private

private extension OneShotViewController {

    func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraintEqualToAnchor(topLayoutGuide.topAnchor).active = true
        stackView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
        stackView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        stackView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true

        navBarExtension.translatesAutoresizingMaskIntoConstraints = false
        navBarExtension.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor).active = true
        navBarExtension.heightAnchor.constraintEqualToConstant(44.0).active = true

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraintEqualToAnchor(navBarExtension.bottomAnchor).active = true
        mapView.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor).active = true
    }

}
