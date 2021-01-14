//
//  ConditionsCheckBoxDelegate.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import Foundation

protocol ConditionsCheckBoxDelegate: class {
    
    func itemSelected(type: ConditionsRadioButtonType)
}
