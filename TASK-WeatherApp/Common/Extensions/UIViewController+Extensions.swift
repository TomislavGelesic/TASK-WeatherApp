//
//  UIViewController+Extensions.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import SnapKit

extension UIViewController {
    
    func showSpinner() {
        
        SpinnerViewManager.addSpinnerView(to: self.view)
    }
    
    func hideSpinner() {
        
        SpinnerViewManager.removeSpinnerView()
    }
    
    func showAPIFailedAlert(for errorMessage: String) {
        #warning("return here")
//        "No weather data for this city, yet!"
        let alert: UIAlertController = {
            let alert = UIAlertController(title: "Sorry", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }()
        
        hideSpinner()
        
        present(alert, animated: true, completion: nil)
    }
    
    func getTopBarHeight() -> CGFloat {
        
        return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func setBackgroundImage(with image: UIImage?) {
        let imageView = UIImageView(image: image)
        
        view.insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.layoutIfNeeded()
    }
}
