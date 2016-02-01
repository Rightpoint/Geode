//
//  LocationAnnotationView.swift
//  Example
//
//  Created by John Watson on 1/31/16.
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


import MapKit
import UIKit


final class LocationAnnotationView: MKAnnotationView {

    static let reuseIdentifier = "com.raizlabs.Geode.Example.location-annotation-view"

    private let blueCircle = CAShapeLayer()

    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        precondition(reuseIdentifier == LocationAnnotationView.reuseIdentifier, "Incorrect reuse identifier specified")
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        layer.addSublayer(blueCircle)

        configureLayerProperties()
        attachAnimations()
    }

    // Failure to implement this method results in the following runtime error:
    // `fatal error: use of unimplemented initializer 'init(frame:)'`
    override init(frame: CGRect) {
        super.init(frame: LayoutConstants.annotationFrame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension LocationAnnotationView {

    struct LayoutConstants {
        static let annotationFrame      = CGRect(x: 0.0, y: 0.0, width: 24.0, height: 24.0)
        static let blueCircleFrame      = LayoutConstants.annotationFrame.insetBy(dx: 4.0, dy: 4.0)
        static let blueCirclePulseInset = CGFloat(1.5)
    }

    func configureLayerProperties() {
        guard let shapeLayer = layer as? CAShapeLayer else {
            fatalError("View's backing layer is not a CAShapeLayer!")
        }

        shapeLayer.path = UIBezierPath(ovalInRect: bounds).CGPath
        shapeLayer.fillColor = UIColor.whiteColor().CGColor
        shapeLayer.shadowColor = UIColor(named: .Black).CGColor
        shapeLayer.shadowOpacity = 0.3
        shapeLayer.shadowRadius = 5.0
        shapeLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        blueCircle.path = UIBezierPath(ovalInRect: LayoutConstants.blueCircleFrame).CGPath
        blueCircle.fillColor = UIColor(named: .Blue).CGColor
    }

    func attachAnimations() {
        attachPathAnimation()
        attachColorAnimation()
    }

    func attachPathAnimation() {
        let animation = animationWithKeyPath("path")
        let rect = LayoutConstants.blueCircleFrame.insetBy(dx: LayoutConstants.blueCirclePulseInset, dy: LayoutConstants.blueCirclePulseInset)
        animation.toValue = UIBezierPath(ovalInRect: rect).CGPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        blueCircle.addAnimation(animation, forKey: animation.keyPath)
    }

    func attachColorAnimation() {
        let animation = animationWithKeyPath("fillColor")
        animation.toValue = UIColor(named: .LightBlue)
        blueCircle.addAnimation(animation, forKey: animation.keyPath)
    }

    func animationWithKeyPath(keyPath: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.autoreverses = true
        animation.repeatCount = HUGE
        animation.duration = 2.0

        return animation
    }

}
