//
//  ConditionsHomeSceneCollectionViewCell.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit

class ConditionsHomeSceneCollectionViewCell: UICollectionViewCell {
    
    let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let conditionValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Value"
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ConditionsHomeSceneCollectionViewCell {
    
    private func setupViews() {
        
        contentView.backgroundColor = .clear
        contentView.addSubviews([conditionImageView, conditionValueLabel])
        
        conditionImageViewConstraints()
        conditionValueLabelConstraints()
    }
    
    private func conditionImageViewConstraints() {
        
        conditionImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(contentView.frame.height/2)
        }
    }
    
    private func conditionValueLabelConstraints() {
        
        conditionValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(conditionImageView.snp.bottom).inset(10)
            make.leading.trailing.bottom.equalTo(contentView).inset(10)
        }
    }
}
