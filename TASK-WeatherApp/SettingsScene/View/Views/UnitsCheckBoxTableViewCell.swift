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
        button.setImage(UIImage(systemName: "circle.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .black
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
        
        setConstranintsOnButton()
        setConstranintsOnButtonDescriptionLabel()
    }
    
    func setConstranintsOnButton() {
        
        radioButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalTo(self)
            make.leading.equalTo(self)
        }
    }
    
    func setConstranintsOnButtonDescriptionLabel() {
        
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
