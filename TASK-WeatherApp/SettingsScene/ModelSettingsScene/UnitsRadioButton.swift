//
//  RadioButton.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

class UnitsRadioButton {
    
    var description: String = ""
    var isActive: Bool = false
    var type: UnitsRadioButtonType = .metric
    
    init(description: String, active: Bool, type: UnitsRadioButtonType) {
        self.description = description
        self.isActive = active
        self.type = type
    }
}
