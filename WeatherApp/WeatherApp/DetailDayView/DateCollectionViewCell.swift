//
//  DateCollectionViewCell.swift
//  WeatherApp
//
//  Created by 유민우 on 8/13/24.
//

import UIKit
import SnapKit

class DateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let id = "DateCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupUI() {
        contentView.backgroundColor = .red
        contentView.layer.cornerRadius = 10
    }
}
