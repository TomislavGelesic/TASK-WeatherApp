//
//  UIViewController+Extensions.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import SnapKit

extension UIViewController {
    
    func showSpinner() { SpinnerViewManager.addSpinnerView(to: self.view) }
    func hideSpinner() { SpinnerViewManager.removeSpinnerView() }
    
    func showAlert(text errorMessage: String, completion: @escaping ()->()) {
        let alert = UIAlertController(title: "Sorry", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in completion() }))
        DispatchQueue.main.async { [unowned self] in self.present(alert, animated: true) }
    }
    
    func getTopBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
