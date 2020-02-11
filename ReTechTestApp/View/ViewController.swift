//
//  ViewController.swift
//  ReTechTestApp
//
//  Created by ora on 03/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let presenter: Presenter

    private let headerLabel = UILabel()
    private let noProductsLabel = UILabel()
    private let saveButton = UIButton()
    private let tableView: ProductsTable
    private let addProductLabel = UILabel()
    private let addButton = UIButton()
    
    private let backgroundColor: UIColor = UIColor(red: 106/255, green: 136/255, blue: 244/255, alpha: 1)
    
    init(_ presenter: Presenter) {
        self.presenter = presenter
        tableView = ProductsTable(presenter.products ?? [], presenter.imagePickerManager)
        
        super.init(nibName: nil, bundle: nil)
        
        presenter.imagePickerManager.viewController = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor  
        
        navigationController?.navigationBar.barTintColor = backgroundColor
        navigationController?.navigationBar.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.allowsSelection = true
        
        addProductLabel.textAlignment = .center
        addProductLabel.text = "Add product"
        addProductLabel.textColor = .white
        
        noProductsLabel.textAlignment = .center
        noProductsLabel.text = "No products"
        noProductsLabel.textColor = .white
        noProductsLabel.isHidden = !tableView.isEmpty
        
        addButton.layer.cornerRadius = 22.5
        addButton.layer.borderColor = UIColor.white.cgColor
        addButton.layer.borderWidth = 1
        
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        addButton.backgroundColor = backgroundColor
        addButton.addTarget(self, action: #selector(addProduct), for: .touchUpInside)
        
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        saveBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        self.navigationItem.rightBarButtonItem  = saveBarButtonItem
        
        let deleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteProduct))
        deleteBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        self.navigationItem.leftBarButtonItem = deleteBarButtonItem
        
        self.navigationItem.title = "Products audit"
        
        view.addSubviews(noProductsLabel, tableView, addProductLabel, addButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalToSuperview()
            }
            
            make.left.right.centerX.equalToSuperview()
            make.bottom.equalTo(addProductLabel.snp.top).offset(-15)
        }
        
        noProductsLabel.snp.makeConstraints { make in
            make.center.width.equalToSuperview()
        }
        
        addProductLabel.snp.makeConstraints { make in
            make.left.right.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(45)
            make.top.equalTo(addProductLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func deleteProduct() {
        tableView.deleteSelectedProduct()
        noProductsLabel.isHidden = !tableView.isEmpty
    }
    
    @objc private func save() {
        presenter.saveProducts(tableView.products)
    }
    
    @objc private func addProduct() {
        tableView.addNewProduct()
        noProductsLabel.isHidden = !tableView.isEmpty
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.easeIn)
        UIView.setAnimationDuration(0.3)
       
        tableView.snp.remakeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalToSuperview()
            }
            
            make.left.right.centerX.equalToSuperview()
            make.bottom.equalTo(addProductLabel.snp.top).offset(-15)
        }
        
        UIView.commitAnimations()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.easeIn)
        UIView.setAnimationDuration(0.3)
        
        guard let userInfo = (notification as NSNotification).userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        tableView.snp.remakeConstraints { make in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                make.top.equalToSuperview()
            }
            
            make.left.right.centerX.equalToSuperview()
            make.bottom.equalTo(addProductLabel.snp.top).offset(-keyboardFrame.height / 2)
        }
        UIView.commitAnimations()
    }
}
