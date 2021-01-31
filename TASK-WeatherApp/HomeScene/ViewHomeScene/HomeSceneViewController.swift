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
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let humidityConditionView: ConditionView = {
        let view = ConditionView()
        return view
    }()
    
    let pressureConditionView: ConditionView = {
        let view = ConditionView()
        return view
    }()
    
    let windConditionView: ConditionView = {
        let view = ConditionView()
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
        
        viewModel.weatherRepository.getData.send(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.refreshUISubject.send()
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
        
        for item in viewModel.getConditionsToShow() {
            switch item {
            case .humidity:
                conditionsStackView.addArrangedSubview(humidityConditionView)
                break
            case .windSpeed:
                conditionsStackView.addArrangedSubview(windConditionView)
                break
            case .pressure:
                conditionsStackView.addArrangedSubview(pressureConditionView)
                break
                
            }
        }
        conditionsStackView.setNeedsLayout()
        
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
                
                self.hideSpinner()
                
                self.conditionsStackView.safelyRemoveArrangedSubviews()
                
                for item in viewModel.getConditionsToShow() {
                    switch item {
                    case .humidity:
                        humidityConditionView.conditionValueLabel.text = viewModel.weatherRepository.data.humidity
                        conditionsStackView.addArrangedSubview(humidityConditionView)
                        setConstraintsOnHumidityConditionView()
                        break
                    case .pressure:
                        pressureConditionView.conditionValueLabel.text = viewModel.weatherRepository.data.pressure
                        conditionsStackView.addArrangedSubview(pressureConditionView)
                        setConstraintsOnPressureConditionView()
                        break
                    case .windSpeed:
                        windConditionView.conditionValueLabel.text = viewModel.weatherRepository.data.windSpeed
                        conditionsStackView.addArrangedSubview(windConditionView)
                        setConstraintsOnWindConditionView()
                        break
                    }
                }
                
                conditionsStackView.layoutIfNeeded()
                
                self.updateWeather(with: viewModel.weatherRepository.data)
                
                
            }
            .store(in: &disposeBag)
        
        viewModel.getData
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (_) in
                self.viewModel.refreshUISubject.send()
            }
            .store(in: &disposeBag)
    }
    
    func updateWeather(with info: WeatherInfo) {
        
        switch viewModel.weatherRepository.userSettings.measurmentUnit {
        case .imperial:
            currentTemperatureLabel.text = "\(info.current_Temperature)" + " F"
            minTemperatureLabel.text = "\(info.min_Temperature)" + " F"
            maxTemperatureLabel.text = "\(info.max_Temperature)" + " F"
            break
        case .metric:
            currentTemperatureLabel.text = "\(info.current_Temperature)" + " °C"
            minTemperatureLabel.text = "\(info.min_Temperature)" + " °C"
            maxTemperatureLabel.text = "\(info.max_Temperature)" + " °C"
            break
        }

        
        cityNameLabel.text = viewModel.weatherRepository.data.cityName.uppercased()
        
        weatherDescriptionLabel.text = viewModel.weatherRepository.data.weatherDescription.uppercased()
        
        
        updateBackgroundImage(for: Int(viewModel.weatherRepository.data.weatherType) ?? 800)
    }
    
    func updateBackgroundImage(for weatherType: Int) {
        
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
            backgroundImageView.image = UIImage(named: "body_image-cloudy")
            break
            
        // Clear // => 800
        default:
            backgroundImageView.image = UIImage(named: "body_image-clear-day")
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
        setConstraintsOnHumidityConditionView()
        setConstraintsOnPressureConditionView()
        setConstraintsOnWindConditionView()
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
            make.height.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraintsOnWeatherDescriptionLabel() {
        weatherDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(10)
            make.width.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraintsOnCityNameLabel() {
        cityNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(50)
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
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
            make.top.equalTo(verticalLine.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.bottom.equalTo(settingsButton.snp.top).offset(-5)
        }
    }
    
    func setConstraintsOnHumidityConditionView() {
        humidityConditionView.snp.makeConstraints { (make) in
            make.width.equalTo(conditionsStackView.frame.width / 4)
            make.height.equalTo(conditionsStackView.frame.height)
        }
    }
    
    func setConstraintsOnPressureConditionView() {
        humidityConditionView.snp.makeConstraints { (make) in
            make.width.equalTo(conditionsStackView.frame.width / 4)
            make.height.equalTo(conditionsStackView.frame.height)
        }
    }
    
    func setConstraintsOnWindConditionView() {
        humidityConditionView.snp.makeConstraints { (make) in
            make.width.equalTo(conditionsStackView.frame.width / 4)
            make.height.equalTo(conditionsStackView.frame.height)
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
