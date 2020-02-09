//
//  ImagePickerManager.swift
//  ReTechTestApp
//
//  Created by ora on 08/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerManager: NSObject {

    private let  picker = UIImagePickerController()
    private let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    weak var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;

    override init(){
        super.init()
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }

    func pickImage(_ callback: @escaping ((UIImage) -> ())) {
        guard let viewController = viewController else { return }
        pickImageCallback = callback;

        alert.popoverPresentationController?.sourceView = viewController.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController?.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            self.viewController?.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    private func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController?.present(picker, animated: true, completion: nil)
    }

//    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
//    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }
}
