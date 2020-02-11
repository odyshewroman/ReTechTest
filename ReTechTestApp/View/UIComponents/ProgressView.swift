//
//  ProgressView.swift
//  ReTechTestApp
//
//  Created by ora on 10/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import UIKit
class CircularProgressView: UIView {
    private var progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    private func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: frame.size.width / 2, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.black.cgColor

        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval, complition: (()->())?) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        if let complition = complition {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: complition)
        }
    }
}
