//
//  Presenter.swift
//  ReTechTestApp
//
//  Created by ora on 11/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import Foundation

class Presenter {
    private let repository: ProductsRepository
    private let internalImagePickerManager: ImagePickerManager
    
    var imagePickerManager: ImagePickerManager { return internalImagePickerManager }
    var products: [Product]? { return repository.get() }
    
    init(repository: ProductsRepository, imagePickerManager: ImagePickerManager) {
        self.repository = repository
        self.internalImagePickerManager = imagePickerManager
    }
    
    func saveProducts(_ products: [Product]) {
        repository.save(products)
    }
}
