//
//  CheckBoxTableViewCell.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

class UnitsCheckBoxTableViewCell: UITableViewCell {
    
    let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .white
        button.backgroundColor = .clear
        return button
    }()
    
    let buttonDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension UnitsCheckBoxTableViewCell {
    
    func setup() {
        
        backgroundColor = .clear
        
        addSubviews([radioButton, buttonDescriptionLabel])
        
        setConstranints_button()
        setConstranints_buttonDescriptionLabel()
    }
    
    func setConstranints_button() {
        
        radioButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalTo(self)
            make.leading.equalTo(self)
        }
    }
    
    func setConstranints_buttonDescriptionLabel() {
        
        buttonDescriptionLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.top.bottom.trailing.equalTo(self)
            make.leading.equalTo(radioButton.snp.trailing).offset(5)
        }
    }
    
    func configure(with item: UnitsRadioButton) {
        
        radioButton.isSelected = item.isActive
        
        buttonDescriptionLabel.text = item.description
    }
    
}
