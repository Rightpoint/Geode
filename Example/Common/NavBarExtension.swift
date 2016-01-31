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
            lonLabel.text = String(format: "Lon: %.5f", arguments: [coordinate.longitude])
            latLabel.text = String(format: "Lat: %.5f", arguments: [coordinate.latitude])
        }
    }

    private let hairline = UIView()
    private let stackView = UIStackView()
    private let lonLabel = UILabel()
    private let latLabel = UILabel()

    init() {
        hairline.backgroundColor = UIColor.blackColor()

        stackView.axis = .Horizontal
        stackView.alignment = .Fill
        stackView.distribution = .FillEqually

        lonLabel.textAlignment = .Center
        latLabel.textAlignment = .Center

        super.init(frame: CGRect.zero)

        addSubview(hairline)
        addSubview(stackView)
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
        hairline.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        hairline.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true
        hairline.heightAnchor.constraintEqualToConstant(1.0 / UIScreen.mainScreen().scale).active = true

        // The stack view is pinned to the top of the view, sits above the
        // hairline, and fills the width of the view.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        stackView.bottomAnchor.constraintEqualToAnchor(hairline.topAnchor).active = true
        stackView.widthAnchor.constraintEqualToAnchor(widthAnchor).active = true

        // The longitude label is pinned to the left of the stack view.
        lonLabel.translatesAutoresizingMaskIntoConstraints = false
        lonLabel.leftAnchor.constraintEqualToAnchor(stackView.leftAnchor).active = true

        // The latitude label is pinned to the right of the stack view.
        latLabel.translatesAutoresizingMaskIntoConstraints = false
        latLabel.rightAnchor.constraintEqualToAnchor(stackView.rightAnchor).active = true
    }

}
