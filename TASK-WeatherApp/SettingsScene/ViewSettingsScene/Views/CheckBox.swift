//
//  CheckBoxWithImage.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

class CheckBox: UIView {

    let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .black
        return button
    }()
    
    let radioButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    init(with image: UIImage?, active: Bool) {
        super.init(frame: .zero)
        
        if let image = image {
            radioButtonImage.image = image
        }
        radioButton.isSelected = active
        
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CheckBox {
    
    func setupViews() {
        
        addSubviews([radioButton, radioButtonImage])
        
        setConstraints_button()
        setConstraints_descriptionImage()
    }
    
    func setConstraints_button() {
        radioButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
    }
    
    func setConstraints_descriptionImage() {
        
        radioButtonImage.snp.makeConstraints { (make) in
            make.top.equalTo(radioButton.snp.bottom).offset(5)
            make.centerX.equalTo(self)
            make.height.width.equalTo(44)
            
            
        }
    }
}
