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
    
//    var radioButtons: [ConditionsRadioButton] = {
//        ConditionsRadioButton(image: UIImage(named: "humidity_icon") ?? UIImage(systemName: "photo"), isChecked: false, type: .humidity),
//        ConditionsRadioButton(image: UIImage(named: "wind_icon") ?? UIImage(systemName: "photo"), isChecked: false, type: .wind),
//        ConditionsRadioButton(image: UIImage(named: "pressure") ?? UIImage(systemName: "photo"), isChecked: false, type: .pressure)
//
//    }
    
    let humidityCheckBoxWithImage: CheckBoxWithImage = {
        let image = UIImage(named: "humidity_icon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        let box = CheckBoxWithImage(with: image, active: false)
        box.backgroundColor = .clear
        return box
    }()
    
    let windCheckBoxWithImage: CheckBoxWithImage = {
        let image = UIImage(named: "wind_icon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        let box = CheckBoxWithImage(with: image, active: false)
        box.backgroundColor = .clear
        return box
    }()
    
    let pressureCheckBoxWithImage: CheckBoxWithImage = {
        let image = UIImage(named: "pressure_icon")?.withRenderingMode(.alwaysTemplate) ?? UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        let box = CheckBoxWithImage(with: image, active: false)
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
        
        setup()
    }
    
    required init(coder: NSCoder?) {
        fatalError()
    }
    
}

extension ConditionsCheckBox {
    
    func setup() {
        
        addSubview(stackView)
        stackView.addArrangedSubview(humidityCheckBoxWithImage)
        stackView.addArrangedSubview(windCheckBoxWithImage)
        stackView.addArrangedSubview(pressureCheckBoxWithImage)
    
        humidityCheckBoxWithImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(humidityRadioButtonTapped)))
        
        windCheckBoxWithImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(windRadioButtonTapped)))
        
        pressureCheckBoxWithImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pressureRadioButtonTapped)))
        
        
        
        setConstraints_stackView()
        setConstraint_humidityCheckBoxWithImage()
        setConstraint_windCheckBoxWithImage()
        setConstraint_pressureCheckBoxWithImage()
    }
    
    func setConstraints_stackView() {
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
    }
    
    func setConstraint_humidityCheckBoxWithImage() {
        humidityCheckBoxWithImage.snp.makeConstraints { (make) in
            make.height.equalTo(self)
        }
    }
    
    func setConstraint_windCheckBoxWithImage() {
        humidityCheckBoxWithImage.snp.makeConstraints { (make) in
            make.height.equalTo(self)
        }
    }
    
    func setConstraint_pressureCheckBoxWithImage() {
        humidityCheckBoxWithImage.snp.makeConstraints { (make) in
            make.height.equalTo(self)
        }
    }
    
    @objc func humidityRadioButtonTapped() {
        delegate?.radioButtonTapped(type: .humidity)
    }
    
    @objc func windRadioButtonTapped() {
        delegate?.radioButtonTapped(type: .wind)
    }
    
    @objc func pressureRadioButtonTapped() {
        delegate?.radioButtonTapped(type: .pressure)
    }
}




