//
//  WeaterDetailCollectionViewCell.swift
//  WeatherApp
//
//  Created by 유민우 on 8/13/24.
//

import UIKit
import SnapKit

final class WeaterDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let id = "WeaterDetailCollectionViewCell"
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "날씨"
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupUI() {
        contentView.backgroundColor = .green
        contentView.layer.cornerRadius = 15
        contentView.addSubview(testLabel)
        
        testLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(50)
        }
    }
    
}


