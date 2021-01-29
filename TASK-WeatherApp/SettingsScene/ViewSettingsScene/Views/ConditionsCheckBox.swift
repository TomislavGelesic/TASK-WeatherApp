//
//  ConditionsCheckBox.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit
import SnapKit

class ConditionsCheckBox: UIView {
    
    weak var delegate: ConditionsRadioButtonDelegate?
    
    let humidityCheckBoxWithImage: CheckBox = {
        
        let image = UIImage(named: "humidity_icon")?.withRenderingMode(.alwaysTemplate)
        
        let box = CheckBox(with: image, active: false)
        box.backgroundColor = .clear
        return box
    }()
    
    let windCheckBoxWithImage: CheckBox = {
        
        let image = UIImage(named: "wind_icon")?.withRenderingMode(.alwaysTemplate)
        
        let box = CheckBox(with: image, active: false)
        box.backgroundColor = .clear
        return box
    }()
    
    let pressureCheckBoxWithImage: CheckBox = {
        
        let image = UIImage(named: "pressure_icon")?.withRenderingMode(.alwaysTemplate)
        
        let box = CheckBox(with: image, active: false)
        box.backgroundColor = .clear
        return box
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setViews()
        setConstraints()
    }
    
    required init(coder: NSCoder?) {
        fatalError()
    }
    
}

extension ConditionsCheckBox {
    
    func setViews() {
        
        addSubview(stackView)
        stackView.addArrangedSubview(humidityCheckBoxWithImage)
        stackView.addArrangedSubview(windCheckBoxWithImage)
        stackView.addArrangedSubview(pressureCheckBoxWithImage)
    
        humidityCheckBoxWithImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(humidityRadioButtonTapped)))
        
        windCheckBoxWithImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(windRadioButtonTapped)))
        
        pressureCheckBoxWithImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressureRadioButtonTapped)))
        
    }
    
    @objc func humidityRadioButtonTapped() {
        
        humidityCheckBoxWithImage.radioButton.isSelected = !humidityCheckBoxWithImage.radioButton.isSelected
        delegate?.radioButtonTapped(type: .humidity)
    }
    
    @objc func windRadioButtonTapped() {
        
        windCheckBoxWithImage.radioButton.isSelected = !windCheckBoxWithImage.radioButton.isSelected
        delegate?.radioButtonTapped(type: .wind)
    }
    
    @objc func pressureRadioButtonTapped() {
        
        pressureCheckBoxWithImage.radioButton.isSelected = !pressureCheckBoxWithImage.radioButton.isSelected
        delegate?.radioButtonTapped(type: .pressure)
    }
    
    func setConstraints() {
        
        setConstraintsOnStackView()
        setConstraintOnHumidityCheckBoxWithImage()
        setConstraintOnWindCheckBoxWithImage()
        setConstraintOnOPressureCheckBoxWithImage()
    }
    
    func setConstraintsOnStackView() {
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
    }
    
    func setConstraintOnHumidityCheckBoxWithImage() {
        humidityCheckBoxWithImage.snp.makeConstraints { (make) in
            make.height.equalTo(self)
        }
    }
    
    func setConstraintOnWindCheckBoxWithImage() {
        humidityCheckBoxWithImage.snp.makeConstraints { (make) in
            make.height.equalTo(self)
        }
    }
    
    func setConstraintOnOPressureCheckBoxWithImage() {
        humidityCheckBoxWithImage.snp.makeConstraints { (make) in
            make.height.equalTo(self)
        }
    }
    
    func setActive(for type: ConditionTypes) {
        
        switch type {
        case .humidity:
            humidityCheckBoxWithImage.radioButton.isSelected = true
        case .pressure:
            pressureCheckBoxWithImage.radioButton.isSelected = true
        case .windSpeed:
            windCheckBoxWithImage.radioButton.isSelected = true
        }
    }
}




