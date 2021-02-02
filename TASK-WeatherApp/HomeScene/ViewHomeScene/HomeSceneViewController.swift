//
//  HomeSceneViewController.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import Combine
import SnapKit

class HomeSceneViewController: UIViewController {
    
    var coordinator: HomeSceneCoordinator
    
    var viewModel: HomeSceneViewModel
    
    var disposeBag = Set<AnyCancellable>()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "body_image-clear-day")
        return imageView
    }()
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = label.font.withSize(30)
        label.text = "Curr T"
        label.textAlignment = .center
        return label
    }()
    
    let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "W desc"
        label.textAlignment = .center
        return label
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "city name".uppercased()
        label.textAlignment = .center
        return label
    }()
    
    let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "min T"
        label.textAlignment = .center
        return label
    }()
    
    let minTemperatureLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "Low"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    let maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "max T"
        label.textAlignment = .center
        return label
    }()
    
    let maxTemperatureLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "High"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let conditionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    let humidityConditionView: ConditionView = {
        let view = ConditionView(image: UIImage(named: "humidity_icon")?.withRenderingMode(.alwaysTemplate))
        view.isHidden = true
        return view
    }()
    
    let pressureConditionView: ConditionView = {
        let view = ConditionView(image: UIImage(named: "pressure_icon")?.withRenderingMode(.alwaysTemplate))
        view.isHidden = true
        return view
    }()
    
    let windConditionView: ConditionView = {
        let view = ConditionView(image: UIImage(named: "wind_icon")?.withRenderingMode(.alwaysTemplate))
        view.isHidden = true
        return view
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.2.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(UIImage(systemName: "gearshape.2")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = .black
        return button
    }()
    
    let searchTextField: UITextField = {
        
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate))
        iconView.tintColor = .black
        
        let textField = UITextField()
        textField.leftView = iconView
        textField.leftViewMode = .always
        textField.placeholder = "Search"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        return textField
    }()
    
    init(coordinator: HomeSceneCoordinator, viewModel: HomeSceneViewModel) {
        
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("HomeSceneViewController deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setSubviews()
        setConstraints()
        setSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getNewScreenData.send(true)
    }
    
}

extension HomeSceneViewController {
    
    func setSubviews() {
        
        view.backgroundColor = .lightGray
        
        view.addSubviews([
            backgroundImageView,
            currentTemperatureLabel,
            weatherDescriptionLabel,
            cityNameLabel,
            conditionsStackView,
            minTemperatureLabel,
            minTemperatureLabelDescription,
            verticalLine,
            maxTemperatureLabel,
            maxTemperatureLabelDescription,
            settingsButton,
            searchTextField
        ])
        
        
        conditionsStackView.addArrangedSubview(humidityConditionView)
        conditionsStackView.addArrangedSubview(pressureConditionView)
        conditionsStackView.addArrangedSubview(windConditionView)
        
        for value in viewModel.getConditionsToShow() {
            switch value {
            case .humidity:
                humidityConditionView.isHidden = false
                break
            case .windSpeed:
                pressureConditionView.isHidden = false
                break
            case .pressure:
                windConditionView.isHidden = false
                break

            }
        }
        
        searchTextField.delegate = self
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    
    @objc func settingsButtonTapped() {
        
        coordinator.goToSettingsScene()
    }
    
    func setSubscribers() {
        
        viewModel.refreshUISubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] () in
                
                self.updateWeather(with: viewModel.screenData)
            }
            .store(in: &disposeBag)
        
        viewModel.initializeScreenData(for: viewModel.getNewScreenData.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        viewModel.alertSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (error) in
                self.showAPIFailedAlert(for: error, completion: {
                    #warning("i wanted to recall network api when user taps ok on alertView")
                    //                    self.viewModel.getNewScreenData.send(true)
                })
            }
            .store(in: &disposeBag)
        
        viewModel.spinnerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (shouldShow) in
                shouldShow ? self.showSpinner() : self.hideSpinner()
            }
            .store(in: &disposeBag)
    }
    
    func updateWeather(with info: WeatherInfo) {
        
        humidityConditionView.isHidden = true
        pressureConditionView.isHidden = true
        windConditionView.isHidden = true
        
        
        cityNameLabel.text = info.cityName.uppercased()
        weatherDescriptionLabel.text = info.weatherDescription.uppercased()
        humidityConditionView.conditionValueLabel.text = info.humidity + " %"
        
        
        updateBackgroundImage(for: Int(info.weatherType) ?? 800, daytime: info.daytime)
        
        for item in viewModel.getConditionsToShow() {
            switch item {
            case .humidity:
                humidityConditionView.isHidden = false
                break
            case .pressure:
                pressureConditionView.isHidden = false
                break
            case .windSpeed:
                windConditionView.isHidden = false
                break
            }
        }
        
        switch viewModel.getUserSettings().measurmentUnit {
        case .imperial:
            currentTemperatureLabel.text = "\(info.current_Temperature)" + " F"
            minTemperatureLabel.text = "\(info.min_Temperature)" + " F"
            maxTemperatureLabel.text = "\(info.max_Temperature)" + " F"
            windConditionView.conditionValueLabel.text = info.windSpeed + " mph"
            pressureConditionView.conditionValueLabel.text = info.pressure + " psi"
            break
        case .metric:
            currentTemperatureLabel.text = "\(info.current_Temperature)" + " °C"
            minTemperatureLabel.text = "\(info.min_Temperature)" + " °C"
            maxTemperatureLabel.text = "\(info.max_Temperature)" + " °C"
            windConditionView.conditionValueLabel.text = info.windSpeed + " km/h"
            pressureConditionView.conditionValueLabel.text = info.pressure + " hPa"
            break
        }
    }
    
    func updateBackgroundImage(for weatherType: Int, daytime: Bool) {
        
        switch weatherType {
        
        // Thunderstorm
        case 200..<300:
            backgroundImageView.image = UIImage(named: "body_image-thunderstorm")
            break
            
        // Drizzle & Rain
        case 300..<600:
            backgroundImageView.image = UIImage(named: "body_image-rain")
            break
            
        // Snow
        case 600..<700:
            backgroundImageView.image = UIImage(named: "body_image-snow")
            break
            
        // Atmosphere
        case 700..<800:
            if weatherType == 741 {
                backgroundImageView.image = UIImage(named: "body_image-fog")
            }
            if weatherType == 781 {
                backgroundImageView.image = UIImage(named: "body_image-tornado")
            }
            break
        // Clouds
        case 801..<810:
            if daytime {
            backgroundImageView.image = UIImage(named: "body_image-partly-cloudy-day")
            break
        }
            backgroundImageView.image = UIImage(named: "body_image-partly-cloudy-night")
            break
            
        // Clear // => 800
        default:
            if daytime {
                backgroundImageView.image = UIImage(named: "body_image-clear-day")
                break
            }
            backgroundImageView.image = UIImage(named: "body_image-clear-night")
            break

        }
    }
}

extension HomeSceneViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        coordinator.goToSearchScene()
        
        return true
    }
}

//MARK: CONSTRAINTS BELOW
extension HomeSceneViewController {
    
    func setConstraints() {
        
        setConstraintsOnBackgroundImageView()
        setConstraintsOnCurrentTemperatureLabel()
        setConstraintsOnWeatherDescriptionLabel()
        setConstraintsOnCityNameLabel()
        setConstraintsOnMinTemperatureLabel()
        setConstraintsOnMinTemperatureLabelDescription()
        setConstraintsOnVerticalLine()
        setConstraintsOnMaxTemperatureLabel()
        setConstraintsOnMaxTemperatureLabelDescription()
        setConstraintsOnConditionsStackView()
        setConstraintsOnSettingsButton()
        setConstraintsOnSearchTextField()
    }
    
    func setConstraintsOnBackgroundImageView() {
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setConstraintsOnCurrentTemperatureLabel() {
        currentTemperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(10)
            make.height.equalTo(80)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraintsOnWeatherDescriptionLabel() {
        weatherDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(10)
            make.width.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(30)
        }
    }
    
    func setConstraintsOnCityNameLabel() {
        cityNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(30)
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(30)
        }
    }
    
    func setConstraintsOnMinTemperatureLabel() {
        minTemperatureLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.trailing.equalTo(verticalLine.snp.leading).offset(-15)
        }
    }
    
    func setConstraintsOnMinTemperatureLabelDescription() {
        minTemperatureLabelDescription.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.bottom.equalTo(verticalLine.snp.bottom).offset(-10)
            make.top.equalTo(minTemperatureLabel.snp.bottom).offset(10)
            make.trailing.equalTo(verticalLine.snp.leading).offset(-15)
        }
    }
    
    func setConstraintsOnVerticalLine() {
        verticalLine.snp.makeConstraints { (make) in
            make.width.equalTo(2)
            make.height.equalTo(90)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraintsOnMaxTemperatureLabel() {
        maxTemperatureLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(verticalLine.snp.trailing).offset(15)
        }
    }
    
    func setConstraintsOnMaxTemperatureLabelDescription() {
        maxTemperatureLabelDescription.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.bottom.equalTo(verticalLine.snp.bottom).offset(-10)
            make.top.equalTo(maxTemperatureLabel.snp.bottom).offset(10)
            make.leading.equalTo(verticalLine.snp.trailing).offset(15)
        }
    }
    
    func setConstraintsOnConditionsStackView() {
        
        conditionsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(verticalLine.snp.bottom).offset(30)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            make.bottom.equalTo(searchTextField.snp.top).offset(-10)
        }
    }
    
    func setConstraintsOnSettingsButton() {
        settingsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.bottom.equalTo(view.snp.bottom).offset(-2)
            make.leading.equalTo(view.snp.leading).offset(10)
        }
        
    }
    
    func setConstraintsOnSearchTextField() {
        searchTextField.snp.makeConstraints { (make) in
            make.width.equalTo(view.frame.width - 44 - 30)
            make.height.equalTo(44)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.bottom.equalTo(view.snp.bottom).offset(-2)
        }
        
    }
}
