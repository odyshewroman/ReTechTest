//
//  ProductsRepository.swift
//  ReTechTestApp
//
//  Created by ora on 04/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import Foundation

class ProductsRepository: Repository {
    typealias StorageData = [Product]
    private let key = "data_key"
    let userDefaults = UserDefaults.standard
    
    func save(_ data: [Product]) {
        let productsData = data.map { ProductData(name: $0.name, count: $0.count, photos: $0.photos) }
        
        userDefaults.set(try? PropertyListEncoder().encode(productsData), forKey: key)
    }
    
    func get() -> [Product]? {
        guard let data = userDefaults.object(forKey: key) as? Data else { return nil }
        
        guard let productsData = try? PropertyListDecoder().decode([ProductData].self, from: data) else { return nil }
        
        return productsData.map { Product(name: $0.name, count: $0.count, photos: $0.photos) }
    }
}
