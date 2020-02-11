//
//  CounterView.swift
//  ReTechTestApp
//
//  Created by ora on 05/02/2020.
//  Copyright © 2020 Roman Odyshev. All rights reserved.
//

import UIKit
import SnapKit

class CounterView: UIView {
    private let countLabel = UILabel()
    private let plusButton = UIButton()
    private let minusButton = UIButton()
    private let countValue = UILabel()
    
    private let buttonsSize: CGFloat = 45
    
    var count: UInt = 0 { didSet { invalidateCounter() }}
    
    init(_ count: UInt = 0) {
        self.count = count
        super.init(frame: .zero)
        countLabel.textAlignment = .center
        self.addSubviews(countLabel, plusButton, minusButton, countValue)
        
       countValue.textAlignment = .center
        
        countLabel.text = "Count"
        countLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.textAlignment = .center
        
        plusButton.setTitle("+", for: UIControl.State())
        plusButton.setTitleColor(UIColor.black, for: UIControl.State())
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        minusButton.setTitle("-", for: UIControl.State())
        minusButton.setTitleColor(UIColor.black, for: UIControl.State())
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        minusButton.addTarget(self, action: #selector(minusTap), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTap), for: .touchUpInside)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func plusTap() {
        count(true)
    }
    
    @objc private func minusTap() {
        count(false)
    }
    
    @objc private func count(_ plus: Bool) {
        if !plus && count == 0 {
            return
        }
        
        if plus {
            count += 1
        } else {
            count -= 1
        }
    }
    
    private func invalidateCounter() {
        countValue.text = count.description
    }
    
    private func makeConstraints() {
        countLabel.snp.makeConstraints { make in
            make.top.left.right.centerX.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.size.equalTo(buttonsSize)
            make.top.equalTo(countLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        countValue.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(buttonsSize)
            make.top.equalTo(countLabel.snp.bottom)
            make.left.equalTo(minusButton.snp.right)
            make.right.equalTo(plusButton.snp.left)
        }
        
        plusButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.size.equalTo(buttonsSize)
            make.top.equalTo(countLabel.snp.bottom)
        }
    }
}
