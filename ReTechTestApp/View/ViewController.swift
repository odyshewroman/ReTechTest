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

    private let repository: ProductsRepository
    
    private let headerLabel = UILabel()
    private let saveButton = UIButton()
    private let tableView: ProductsTable
    
    private let addProductLabel = UILabel()
    private let addButton = UIButton()
    
    private let backgroundColor: UIColor = UIColor(red: 106/255, green: 136/255, blue: 244/255, alpha: 1)
    
    init(_ repository: ProductsRepository, _ imagePickerManager: ImagePickerManager) {
        tableView = ProductsTable(repository.get() ?? [], imagePickerManager)
        self.repository = repository
        
        super.init(nibName: nil, bundle: nil)
        
        imagePickerManager.viewController = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = backgroundColor
        
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.backgroundColor = backgroundColor
        
        view.backgroundColor = backgroundColor
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.backgroundColor = .clear
        
        addProductLabel.textAlignment = .center
        addProductLabel.text = "Add product"
        addProductLabel.textColor = .white
        addButton.backgroundColor = .red
        
        tableView.separatorColor = .clear
        
        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        saveBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
        self.navigationItem.rightBarButtonItem  = saveBarButtonItem
        
        let deleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteProduct))
        deleteBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        self.navigationItem.leftBarButtonItem = deleteBarButtonItem
        
        self.navigationItem.title = "Products audit"
    
        tableView.allowsSelection = true
        
        view.addSubview(tableView)
        view.addSubview(addProductLabel)
        view.addSubview(addButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        makeConstraints()
        
        addButton.addTarget(self, action: #selector(addProduct), for: .touchUpInside)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func deleteProduct() {
        tableView.deleteSelectedProduct()
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.easeIn)
        UIView.setAnimationDuration(0.3)
     //   self.tableView.transform = .identity
       
        
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
//
//        let offset: CGFloat = 10
//        let bottomElement = self.tableView.frame.origin.y + self.tableView.frame.height
//        let keyboardTop = self.view.frame.height - keyboardFrame.height
//        let verticalShift = keyboardTop - bottomElement - offset
//
//        if verticalShift < 0 {
//            self.view.transform = CGAffineTransform(translationX: 0, y: verticalShift)
//        }
        
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
    
    @objc private func save() {
        repository.save(tableView.products)
    }
    
    @objc private func addProduct() {
        tableView.addNewProduct()
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
          //  make.bottom.lessThanOrEqualTo(addProductLabel.snp.top).inset(15)
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
}
