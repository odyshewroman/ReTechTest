//
//  ProductImageView.swift
//  ReTechTestApp
//
//  Created by ora on 09/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import UIKit
import SnapKit

class ProductImageView: UIView {
    private let imageView: UIImageView
    private let closeButton: UIButton
    
    weak var deleteProductImageDelegate: DeleteProductImageDelegate?
    var circularView: CircularProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    var image: UIImage? { return imageView.image }
    
    init(_ image: UIImage?) {
        imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        closeButton = UIButton()
        
        closeButton.backgroundColor = .red
        closeButton.layer.cornerRadius = 3
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        closeButton.isHidden = image == nil
        super.init(frame: .zero)
        
        closeButton.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)
        self.addSubviews(imageView, closeButton, circularView)

        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(closeButton.snp.left).offset(-5)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        
        circularView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(-10)
            make.size.equalTo(40)
        }
    }
    
    @objc private func deleteTap() {
        deleteProductImageDelegate?.deleteProductImage(self)
    }
    
    func loadImage(_ image: UIImage) {
        alpha = 0.6
        imageView.image = image
        
        closeButton.isHidden = true
        circularView.isHidden = false
        
        circularView.progressAnimation(duration: 2.5) { [weak self] in
            self?.circularView.isHidden = true
            self?.closeButton.isHidden = false
            self?.alpha = 1
        }
    }
}

protocol DeleteProductImageDelegate: class {
    func deleteProductImage(_ productImage: ProductImageView)
}
