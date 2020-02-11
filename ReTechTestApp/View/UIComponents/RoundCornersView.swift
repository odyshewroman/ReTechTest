//
//  RoundCornersView.swift
//  ReTechTestApp
//
//  Created by ora on 11/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import UIKit

public class RoundCornersView: UIView {
    public var roundedCorners: UIRectCorner { didSet { hasChanges = oldValue != roundedCorners } }
    public var cornerRadius: Int { didSet { hasChanges = oldValue != cornerRadius } }
    
    private var hasChanges: Bool = false
    
    public init(_ roundedCorners: UIRectCorner, _ cornerRadius: Int) {
        self.roundedCorners = roundedCorners
        self.cornerRadius = cornerRadius
        hasChanges = true
        
        super.init(frame: .zero)
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundedCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask

        super.draw(rect)
    }
}
