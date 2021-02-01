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
        imageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    let conditionValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Value"
        label.textAlignment = .center
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
            make.top.equalTo(self).offset(5)
            make.centerX.equalTo(self)
            
            /*
             .priority = 999;
             
             enables 'isHidden' property auto-animation (on stackView arranged subview) to
             take over process of setting frame to CGRect.zero and hide it
            */
            make.width.height.equalTo(70).priority(999)
        }
    }
    
    private func conditionValueLabelConstraints() {
        
        conditionValueLabel.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(20)
            make.top.equalTo(conditionImageView.snp.bottom).offset(10)
            make.centerX.bottom.equalTo(self)
        }
    }
}

