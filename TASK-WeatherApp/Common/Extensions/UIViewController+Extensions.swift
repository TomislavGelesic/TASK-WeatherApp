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
    
    func updateBackgroundImage() {
        
        let imageView = UIImageView(frame: view.frame)
        let weatherType = Int(UserDefaultsService.fetchUpdated().weatherType)
        let dayTime = UserDefaultsService.fetchUpdated().dayTime

        switch weatherType {
        // Thunderstorm
        case 200..<300: imageView.image = UIImage(named: "body_image-thunderstorm")
        // Drizzle & Rain
        case 300..<600: imageView.image = UIImage(named: "body_image-rain")
        // Snow
        case 600..<700: imageView.image = UIImage(named: "body_image-snow")
        // Atmosphere
        case 700..<800:
            if weatherType == 741 { imageView.image = UIImage(named: "body_image-fog") }
            if weatherType == 781 { imageView.image = UIImage(named: "body_image-tornado") }
            imageView.image = UIImage(named: "body_image-fog")
        // Clouds
        case 801..<810:
            if dayTime { imageView.image = UIImage(named: "body_image-partly-cloudy-day") }
            else { imageView.image = UIImage(named: "body_image-partly-cloudy-night") }
        // Clear == 800, or others - currently don't exist on server
        default:
            if dayTime { imageView.image = UIImage(named: "body_image-clear-day") }
            else { imageView.image = UIImage(named: "body_image-clear-night") }
        }
        imageView.setNeedsLayout()
        view.insertSubview(imageView, at: 0)
        view.layoutIfNeeded()
    }
}
