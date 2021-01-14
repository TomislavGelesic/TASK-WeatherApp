//
//  UICollectionView+Extensions.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell> (for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable collection view cell.")
        }
        
        return cell
    }
}
