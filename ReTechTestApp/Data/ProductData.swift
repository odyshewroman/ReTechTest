//
//  ProductWrapper.swift
//  ReTechTestApp
//
//  Created by ora on 09/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import Foundation

struct ProductData: Codable {
    let name: String?
    let count: UInt
    let photos: [Data]
}
