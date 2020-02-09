//
//  ProductsTable.swift
//  ReTechTestApp
//
//  Created by ora on 04/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import UIKit

class ProductsTable: UITableView {
    private var cells: [ProductCell] = [ProductCell]()
    private var selectedCell: ProductCell? = nil
    private let imagePickerManager: ImagePickerManager
    
    var products: [Product] { return cells.map { $0.product } }
    
    init(_ products: [Product], _ imagePickerManager: ImagePickerManager) {
        self.imagePickerManager = imagePickerManager
        super.init(frame: .zero, style: .plain)
        
        products.forEach {
            let cell = ProductCell(product: $0)
            cell.delegate = self
            cell.imagePickerManager = imagePickerManager
            cells.append(cell)
        }
        
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 250
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    func addNewProduct() {
        let p = Product(name: "Hello", count: 10, photos: [])
        let cell = ProductCell(product: p)
        cell.delegate = self
        cell.imagePickerManager = imagePickerManager
        cells.insert(cell, at: 0)
        
        beginUpdates()
        insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        endUpdates()
        self.invalidateIntrinsicContentSize()
    }
    
    func deleteSelectedProduct() {
        guard let index = cells.firstIndex(where: { $0.isSelected }) else { return }
        cells.remove(at: index)
        beginUpdates()
        deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        endUpdates()
        self.invalidateIntrinsicContentSize()
    }
}

extension ProductsTable: CellDelegate {
    func contentDidChange(cell: UITableViewCell) {
        beginUpdates()
        endUpdates()
        invalidateIntrinsicContentSize()
    }
}

extension ProductsTable: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 285
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < cells.count else {
            return UITableViewCell(frame: .zero)
        }

        return cells[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if cells[indexPath.row].isSelected {
            self.delegate?.tableView?(self, willDeselectRowAt: indexPath)
            self.deselectRow(at: indexPath, animated: false)
            self.delegate?.tableView?(self, didDeselectRowAt: indexPath)
            //cells[indexPath.row].isSelected = false
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cells[indexPath.row].isSelected = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        cells[indexPath.row].isSelected = false
    }
}

protocol CellDelegate: class {
    func contentDidChange(cell: UITableViewCell)
}
