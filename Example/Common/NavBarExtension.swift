//
//  NavBarExtension.swift
//  Example
//
//  Created by John Watson on 1/30/16.
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
import UIKit

final class NavBarExtension: UIView {

    var coordinate = kCLLocationCoordinate2DInvalid {
        didSet {
            if coordinate == kCLLocationCoordinate2DInvalid {
                stackView.isHidden = true
                noLocationLabel.isHidden = false
            }
            else {
                lonLabel.text = String(format: "Lon: %.5f", coordinate.longitude)
                latLabel.text = String(format: "Lat: %.5f", coordinate.latitude)

                stackView.isHidden = false
                noLocationLabel.isHidden = true
            }
        }
    }

    fileprivate let hairline = UIView()
    fileprivate let stackView = UIStackView()
    fileprivate let lonLabel = UILabel()
    fileprivate let latLabel = UILabel()
    fileprivate let noLocationLabel = UILabel()

    init() {
        hairline.backgroundColor = UIColor(named: .black)

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        lonLabel.textColor = UIColor(named: .white)
        lonLabel.textAlignment = .center

        latLabel.textColor = UIColor(named: .white)
        latLabel.textAlignment = .center

        noLocationLabel.text = "Location not available"
        noLocationLabel.textColor = UIColor(named: .white)
        noLocationLabel.textAlignment = .center

        super.init(frame: CGRect.zero)

        backgroundColor = UIColor(named: .purple)

        addSubview(hairline)
        addSubview(stackView)
        addSubview(noLocationLabel)

        stackView.addArrangedSubview(lonLabel)
        stackView.addArrangedSubview(latLabel)

        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private

private extension NavBarExtension {

    func configureConstraints() {
        // The hairline view sits at the bottom of the view, has a fixed
        // height, and fills the width of the view.
        hairline.translatesAutoresizingMaskIntoConstraints = false
        hairline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        hairline.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        hairline.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale).isActive = true

        // The stack view is pinned to the top of the view, sits above the
        // hairline, and fills the width of the view.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: hairline.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        // The longitude label is pinned to the left of the stack view.
        lonLabel.translatesAutoresizingMaskIntoConstraints = false
        lonLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true

        // The latitude label is pinned to the right of the stack view.
        latLabel.translatesAutoresizingMaskIntoConstraints = false
        latLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true

        // The no location label fills the view, in the same position as the
        // stack view.
        noLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        noLocationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noLocationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

}
