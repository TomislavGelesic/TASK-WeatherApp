//
//  SpinnerViewManager.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import SnapKit

class SpinnerViewManager {
    
    static let spinerView: SpinnerView = {
        let spinner = SpinnerView()
        return spinner
    }()
    
    static func addSpinnerView(to view: UIView) {
        
        view.addSubview(spinerView)
        
        spinerView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    static func removeSpinnerView() {
        
        spinerView.removeFromSuperview()
    }
    
}
