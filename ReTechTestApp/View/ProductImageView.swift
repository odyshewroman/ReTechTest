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
    
    var image: UIImage? { return imageView.image }
    
    init(_ image: UIImage) {
        imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        closeButton = UIButton()
        
        closeButton.backgroundColor = .red
        closeButton.layer.cornerRadius = 3
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        super.init(frame: .zero)
        
        
        print("Test1: cache2 \(image.hashValue)  \(image.hash) ")
        
        closeButton.addTarget(self, action: #selector(deleteTap), for: .touchUpInside)
        self.addSubviews(imageView, closeButton)
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
    }
    
    @objc private func deleteTap() {
        deleteProductImageDelegate?.deleteProductImage(self)
    }
}

protocol DeleteProductImageDelegate: class {
    func deleteProductImage(_ productImage: ProductImageView)
}
