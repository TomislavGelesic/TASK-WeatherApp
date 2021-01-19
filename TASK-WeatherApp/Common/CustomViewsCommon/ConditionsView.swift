//
//  ConditionsView.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 18.01.2021..
//

import UIKit
import SnapKit

class ConditionView: UIView {
    
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
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConditionView {
    
    private func setupViews() {
        
        backgroundColor = .clear
        addSubviews([conditionImageView, conditionValueLabel])
        
        conditionImageViewConstraints()
        conditionValueLabelConstraints()
    }
    
    private func conditionImageViewConstraints() {
        
        conditionImageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
            make.height.equalTo(self.frame.height/2)
        }
    }
    
    private func conditionValueLabelConstraints() {
        
        conditionValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(conditionImageView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(self).inset(UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10))
        }
    }
}

