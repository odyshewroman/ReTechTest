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
    
    private let addPhotosPanel = UIView()
    private let photosLabel = UILabel()
    private let switchElement = UISwitch()
    
    private let photosPanel = UIView()
    private let photosScroll = UIScrollView()
    private let stackView = UIStackView()
    private let plusPhotoButton = UIButton()
    
    var imagePickerManager: ImagePickerManager?
    
    var product: Product { didSet { updatetView() } }
    
    override var isSelected: Bool {
        didSet { self.view.backgroundColor = isSelected ? UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1) : .white }
    }
    
    weak var delegate: CellDelegate?
    
    private var hasName: Bool { return product.name != nil }
    
    init(product: Product) {
        self.product = product
        
        super.init(style: .default, reuseIdentifier: nil)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(view)
        
        addPhotosPanel.addSubview(photosLabel)
        addPhotosPanel.addSubview(switchElement)
        
        photosScroll.addSubview(stackView)
        photosPanel.addSubview(plusPhotoButton)
        photosPanel.addSubview(photosScroll)
        
        counterView.delegate = self
        
        view.addSubview(nameTextField)
        view.addSubview(name)
        view.addSubview(closeButton)
        view.addSubview(counterView)
        view.addSubview(addPhotosPanel)
        view.addSubview(photosPanel)
        
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
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 6, height: 6)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        
        photosLabel.text = "Attach photos"
        addPhotosPanel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        
        switchElement.addTarget(self, action: #selector(switchChange), for: .valueChanged)
        
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        photosPanel.isHidden = true
        
        makeConstraints()
        
        updatetView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addPhotoTap() {
        imagePickerManager?.pickImage() { [unowned self] image in
            
//            let imageView = UIImageView(image:  self.resizeImage(image: image, targetSize: CGSize(width: 100, height: 100)))
//            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//            imageView.contentMode = .scaleAspectFit
            
            guard let data = image.jpegData(compressionQuality: 1) else { return }
            
            self.product.photos.append(data)
        }
    }
    
    private func addImageToStack(_ image: UIImage) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        
        self.stackView.addArrangedSubview(imageView)
        self.stackView.sizeToFit()
    }
    
    @objc private func clearName() {
        product.name = nil
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    @objc private func switchChange() {
        updatePhotosPanel()
    }
    
    private func updatePhotosPanel() {
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
           // make.height.equalToSuperview()
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
            // sideOffset
            make.left.equalTo(plusPhotoButton.snp.right).offset(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updatetView() {
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
        
        if product.photos.count != stackView.arrangedSubviews.count {
            product.photos.forEach { data in
                if let image = UIImage(data: data) {
                    if stackView.arrangedSubviews.contains(where: { view in
                        guard let uiImageView = view as? UIImageView else { return false }
                        return image.isEqual(uiImageView.image)
                       // return uiImageView.image?.jpegData(compressionQuality: 1) == data
                    }) { return }
                    
                    addImageToStack(image)
                }
            }
        }
        
        switchElement.setOn(true, animated: false)
        updatePhotosPanel()
        
        setNeedsLayout()
    }
}

extension ProductCell: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
}

extension ProductCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        product.name = text
        updatetView()
    }
}

extension ProductCell: CountChangeDelegate {
    func countChange(_ count: UInt) {
        product.count = count
    }
}
