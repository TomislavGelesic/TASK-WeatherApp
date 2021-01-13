//
//  UICollectionViewCell+Extensions.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit

extension UICollectionViewCell: ReusableView {
    
    static var reuseIdentifier: String {
        
        return String(describing: self)
    }
}
