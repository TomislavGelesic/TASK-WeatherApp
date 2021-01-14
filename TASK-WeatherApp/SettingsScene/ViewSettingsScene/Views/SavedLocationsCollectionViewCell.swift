//
//  SavedLocationsCollectionViewCell.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

class SavedLocationsCollectionViewCell: UICollectionViewCell {
    
    var removeButtonAction: (() ->())?
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "city name".uppercased()
        label.textAlignment = .center
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply.square")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "multiply.square.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SavedLocationsCollectionViewCell {
    
    func setupViews() {
        
        contentView.addSubviews([removeButton, cityNameLabel])
        
        setConstraints_removeButton()
        setConstraints_cityNameLabel()
        
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    func setConstraints_removeButton() {
        
        removeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.leading.top.equalTo(contentView).offset(5)
        }
    }
    
    func setConstraints_cityNameLabel() {
        
        cityNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(removeButton.snp.trailing)
            make.trailing.equalTo(contentView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
            make.top.bottom.equalTo(removeButton)
        }
    }
    
    func configure(with name: String) {
        
        cityNameLabel.text = name.uppercased()
    }
    
    @objc func removeButtonTapped() {
        
        removeButtonAction?()
    }
}
