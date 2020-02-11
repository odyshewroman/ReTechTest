//
//  ProductCell.swift
//  ReTechTestApp
//
//  Created by ora on 04/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class ProductCell: UITableViewCell {
    private let sideOffset: CGFloat = 8
    
    private let view = UIView()
    
    private let nameTextField = UITextField()
    private let name = UILabel()
    private let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
    
    private let counterView = CounterView()
    
    private let addPhotosPanel = RoundCornersView([UIRectCorner.bottomLeft, UIRectCorner.bottomRight], 10)
    private let photosLabel = UILabel()
    private let switchElement = UISwitch()
    
    private let photosPanel = UIView()
    private let photosScroll = UIScrollView()
    private let stackView = UIStackView()
    private let plusPhotoButton = UIButton()
    
    var imagePickerManager: ImagePickerManager?
    
    override var isSelected: Bool {
        didSet { self.view.backgroundColor = isSelected ? UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1) : .white }
    }
    
    weak var delegate: CellDelegate?
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(view)
        
        addPhotosPanel.addSubviews(photosLabel, switchElement)
        photosScroll.addSubview(stackView)
        photosPanel.addSubviews(plusPhotoButton, photosScroll)
        
        view.addSubviews(nameTextField, name, closeButton, counterView, addPhotosPanel, photosPanel)
        
        photosScroll.isScrollEnabled = true
        photosScroll.isPagingEnabled = true
        
        closeButton.backgroundColor = .red
        closeButton.layer.cornerRadius = 12
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        closeButton.addTarget(self, action: #selector(clearName), for: .touchUpInside)
        
        plusPhotoButton.setTitle("+", for: .normal)
        plusPhotoButton.setTitleColor(UIColor.black.withAlphaComponent(0.4), for: .normal)
        plusPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        plusPhotoButton.addTarget(self, action: #selector(addPhotoTap), for: .touchUpInside)
        
        nameTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        nameTextField.placeholder = "Enter name of the product"
        nameTextField.delegate = self
        nameTextField.setLeftPaddingPoints(5)
        
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 6, height: 6)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 1
        
        photosLabel.text = "Attach photos"
        addPhotosPanel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        
        switchElement.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        photosPanel.isHidden = true
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstraints() {
        view.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10).priority(999)
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.top.equalToSuperview().offset(sideOffset)
            make.right.equalToSuperview().inset(10)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(sideOffset)
            make.height.equalTo(30)
        }
        
        name.snp.makeConstraints { make in
            make.top.left.right.equalTo(nameTextField)
            make.height.equalTo(30)
        }
        
        counterView.snp.makeConstraints { make in
            make.left.equalTo(nameTextField)
            make.top.equalTo(name.snp.bottom).offset(5)
            make.height.equalTo(60)
        }
        
        addPhotosPanel.snp.makeConstraints { make in
            make.top.equalTo(counterView.snp.bottom).offset(sideOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
            
            if switchElement.isOn {
                make.bottom.equalTo(photosPanel.snp.top)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
        photosLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(sideOffset)
            make.centerY.equalToSuperview()
            make.right.equalTo(switchElement.snp.left).inset(5)
        }
        
        switchElement.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(sideOffset)
            make.top.equalToSuperview().inset(2)
            make.height.equalTo(35)
        }
        
        photosPanel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(sideOffset)
            make.centerX.bottom.equalToSuperview()
            
            if stackView.arrangedSubviews.count == 0 {
                make.height.equalTo(35)
            } else {
                make.height.equalTo(100)
            }
        }
        
        plusPhotoButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(sideOffset)
        }

        photosScroll.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(sideOffset)
            make.bottom.equalToSuperview().inset(sideOffset)
            make.left.equalTo(plusPhotoButton.snp.right).offset(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func addPhotoTap() {
        imagePickerManager?.pickImage() { [unowned self] image in
            self.addImageToStack(image, true)
        }
    }
    
    private func addImageToStack(_ image: UIImage, _ load: Bool = false) {
        let productImageView = ProductImageView(load ? nil : image)
    
        productImageView.deleteProductImageDelegate = self
        productImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        
        self.stackView.addArrangedSubview(productImageView)
        self.stackView.sizeToFit()
        remakeConstraints()
        
        if load {
            productImageView.loadImage(image)
        }
    }
    
    @objc private func clearName() {
        name.text = nil
        name.isHidden = true
        nameTextField.isHidden = false
        
        closeButton.isHidden = name.isHidden
    }
    
    @objc private func switchChange() {
        updatePhotosPanel()
    }
    
    private func updatePhotosPanel() {
        if switchElement.isOn {
            addPhotosPanel.roundedCorners = []
        } else {
            addPhotosPanel.roundedCorners = [.bottomLeft, .bottomRight]
        }

        addPhotosPanel.setNeedsDisplay()
        
        photosPanel.isHidden = !switchElement.isOn
        photosPanel.isOpaque = switchElement.isOn
        
        remakeConstraints()
        
        delegate?.contentDidChange(cell: self)
    }
    
    private func remakeConstraints() {
        addPhotosPanel.snp.remakeConstraints { make in
            make.top.equalTo(counterView.snp.bottom).offset(sideOffset)
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
            
            if switchElement.isOn {
                make.bottom.equalTo(photosPanel.snp.top)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
        photosPanel.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(sideOffset)
            make.centerX.bottom.equalToSuperview()
            
            if stackView.arrangedSubviews.count == 0 {
                make.height.equalTo(35)
            } else {
                make.height.equalTo(100 + 2 * sideOffset)
            }
        }
    }
    
    func getProduct() -> Product {
        let name: String?
        
        name = self.name.isHidden ? nil : self.name.text
        
        var photos = [Data]()
        
        stackView.arrangedSubviews.forEach {
            guard let productImageView = $0 as? ProductImageView else { return }
            guard let data = productImageView.image?.jpegData(compressionQuality: 1) else { return }
            
            photos.append(data)
        }
        
        return Product(name: name, count: counterView.count, photos: photos)
    }
    
    func setProduct(_ product: Product) {
        counterView.count = product.count
        
        if let productName = product.name {
            name.text = productName
            name.isHidden = false
            nameTextField.isHidden = true
        } else {
            name.text = nil
            name.isHidden = true
            nameTextField.isHidden = false
        }
        
        closeButton.isHidden = name.isHidden
        
        if product.photos.count == 0 {
            switchElement.setOn(false, animated: false)
            updatePhotosPanel()
            return
        }
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview()}
        
        product.photos.forEach { data in
            if let image = UIImage(data: data) {
                addImageToStack(image)
            }
        }
        
        switchElement.setOn(true, animated: false)
        updatePhotosPanel()
    }
}

extension ProductCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        name.text = text
        name.isHidden = false
        nameTextField.isHidden = true
        closeButton.isHidden = name.isHidden
    }
}

extension ProductCell: DeleteProductImageDelegate {
    func deleteProductImage(_ productImage: ProductImageView) {
        stackView.removeArrangedSubview(productImage)
    }
}
