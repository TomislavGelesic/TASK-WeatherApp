//
//  ConditionsCheckBoxCollectionViewCell.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

class ConditionsCheckBoxCollectionViewCell: UICollectionViewCell {
    
    let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.fill"), for: .selected)
        return button
    }()
    
    let descriptionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ConditionsCheckBoxCollectionViewCell {
    
    func setupViews() {
        contentView.addSubviews([button, descriptionImage])
        
        setConstraints_button()
        setConstraints_descriptionImage()
    }
    
    func setConstraints_button() {
        button.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(5)
        }
    }
    
    func setConstraints_descriptionImage() {
        
        descriptionImage.snp.makeConstraints { (make) in
            let width = self.frame.size.width
            make.width.height.equalTo(width)
            make.top.equalTo(button.snp.bottom).offset(5)
            
        }
    }
    
    func configure(with image: UIImage) {
        
        descriptionImage.image = image
    }
}
