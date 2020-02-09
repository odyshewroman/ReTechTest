//
//  Repository.swift
//  ReTechTestApp
//
//  Created by ora on 04/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

protocol Repository {
    associatedtype StorageData
    
    func save(_ data: StorageData)
    
    func get() -> StorageData?
}
