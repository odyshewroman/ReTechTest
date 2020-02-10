//
//  UIExtensions.swift
//  ReTechTestApp
//
//  Created by ora on 09/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UIImage {
    func isEqual(_ image: UIImage) -> Bool {
        guard let data = self.pngData() else {
            return false
        }
        
        guard let data2 = image.pngData() else { return false }
        
        return data2.hashValue == data.hashValue
    }
}
