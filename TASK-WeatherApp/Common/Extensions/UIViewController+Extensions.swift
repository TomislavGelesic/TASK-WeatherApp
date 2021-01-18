//
//  UIViewController+Extensions.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
extension UIViewController {
    
    func showSpinner() {
        
        SpinnerViewManager.addSpinnerView(to: self.view)
    }
    
    func hideSpinner() {
        
        SpinnerViewManager.removeSpinnerView()
    }
    
    func showAPIFailedAlert(for errorMessage: String, completion: (() -> ())?) {
        
        let alert: UIAlertController = {
            let alert = UIAlertController(title: "Error", message: "Ups, error occured!\n\(errorMessage)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }()
        
        hideSpinner()
        
        present(alert, animated: true, completion: nil)
    }
    
    func getTopBarHeight() -> CGFloat {
        
        return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
