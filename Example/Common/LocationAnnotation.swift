//
//  LocationAnnotation.swift
//  Example
//
//  Created by John Watson on 1/30/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import MapKit


final class LocationAnnotation: NSObject {

    private let location: CLLocation

    init(location: CLLocation) {
        self.location = location
    }

}

extension LocationAnnotation: MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }

}
