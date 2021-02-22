//
//  HomeSceneViewController.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import Combine
import SnapKit
import CoreLocation

class HomeSceneViewController: UIViewController {
    
    var viewModel: HomeSceneViewModel
    var disposeBag = Set<AnyCancellable>()
    var locationManager: CLLocationManager
    var initialSetup: Bool = true
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = label.font.withSize(30)
        label.textAlignment = .center
        return label
    }()
    
    let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
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
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 50.0), forImageIn: .normal)
        return button
    }()
    
    let searchTextField: UITextField = {
        let img = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30.0))
        let iconView = UIImageView(image: img?.withRenderingMode(.alwaysTemplate))
        iconView.tintColor = .black
        let textField = UITextField()
        textField.leftView = iconView
        textField.leftViewMode = .always
        textField.placeholder = "Search"
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1)
        return textField
    }()
    
    init(viewModel: HomeSceneViewModel) {
        self.viewModel = viewModel
        self.locationManager = CLLocationManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit { print("HomeSceneViewController deinit") }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setConstraints()
        setSubscribers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationServices()
    }
}

extension HomeSceneViewController {
    
    func setSubviews() {
        view.backgroundColor = .lightGray
        view.addSubviews([
            backgroundImage,
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
        
        conditionsStackView.addArrangedSubview(UIView())
        conditionsStackView.addArrangedSubview(humidityConditionView)
        conditionsStackView.addArrangedSubview(pressureConditionView)
        conditionsStackView.addArrangedSubview(windConditionView)
        conditionsStackView.addArrangedSubview(UIView())
        
        for value in viewModel.getConditionsToShow() {
            switch value {
            case .humidity: humidityConditionView.isHidden = false
            case .windSpeed: pressureConditionView.isHidden = false
            case .pressure: windConditionView.isHidden = false
            }
        }
        searchTextField.delegate = self
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    
    func updateBackgroundImage(_ info: WeatherInfo) {
        
        var image = UIImage(systemName: "photo")
        let weatherType = info.weatherType
        let dayTime = info.daytime

        switch weatherType {
        // Thunderstorm
        case 200..<300: image = UIImage(named: "body_image-thunderstorm")
        // Drizzle & Rain
        case 300..<600: image = UIImage(named: "body_image-rain")!
        // Snow
        case 600..<700: image = UIImage(named: "body_image-snow")
        // Atmosphere
        case 700..<800:
            if weatherType == 741 { image = UIImage(named: "body_image-fog") }
            if weatherType == 781 { image = UIImage(named: "body_image-tornado") }
            image = UIImage(named: "body_image-fog")
        // Clouds
        case 801..<810:
            if dayTime { image = UIImage(named: "body_image-partly-cloudy-day") }
            else { image = UIImage(named: "body_image-partly-cloudy-night") }
        // Clear == 800, or others - currently don't exist on server
        default:
            if dayTime { image = UIImage(named: "body_image-clear-day") }
            else { image = UIImage(named: "body_image-clear-night") }
        }
        backgroundImage.image = image
        backgroundImage.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc func settingsButtonTapped() { viewModel.settingsTapped() }
    
    func setSubscribers() {
        
        viewModel.refreshUISubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] () in
                self.updateUI()
            }
            .store(in: &disposeBag)
        
        viewModel.initializeWeatherSubject(subject: viewModel.weatherSubject.eraseToAnyPublisher())
            .store(in: &disposeBag)
        
        viewModel.alertSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (error) in
                self.showAlert(text: error) { [unowned self] in
                    self.checkLocationServices()
                    print("calling this")
                }
            }
            .store(in: &disposeBag)
        
        viewModel.spinnerSubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (shouldShow) in shouldShow ? self.showSpinner() : self.hideSpinner() }
            .store(in: &disposeBag)
    }
    
    func updateUI() {
        viewModel.isDayTime() ? setTextColor(UIColor.black) : setTextColor(UIColor.white)
        setScreenText(with: viewModel.screenData, for: viewModel.getMeasurementUnit())
        updateConditions(with: viewModel.getConditionsToShow())
        updateBackgroundImage(viewModel.screenData)
    }
    
    func setTextColor(_ color: UIColor) {
        cityNameLabel.textColor = color
        weatherDescriptionLabel.textColor = color
        currentTemperatureLabel.textColor = color
        minTemperatureLabel.textColor = color
        maxTemperatureLabel.textColor = color
        windConditionView.conditionValueLabel.textColor = color
        pressureConditionView.conditionValueLabel.textColor = color
        humidityConditionView.conditionValueLabel.textColor = color
    }
    
    func updateConditions(with conditions: [ConditionTypes]) {
        humidityConditionView.isHidden = true
        pressureConditionView.isHidden = true
        windConditionView.isHidden = true
        for item in conditions {
            switch item {
            case .humidity: humidityConditionView.isHidden = false
            case .pressure: pressureConditionView.isHidden = false
            case .windSpeed: windConditionView.isHidden = false
            }
        }
    }
    
    func setScreenText(with info: WeatherInfo, for unit: MeasurementUnits) {
        cityNameLabel.text = info.cityName.uppercased()
        weatherDescriptionLabel.text = info.weatherDescription.uppercased()
        humidityConditionView.conditionValueLabel.text = info.humidity + " [%]"
        switch unit {
        case .imperial:
            currentTemperatureLabel.text = "\(info.current_Temperature)" + " F"
            minTemperatureLabel.text = "\(info.min_Temperature)" + " F"
            maxTemperatureLabel.text = "\(info.max_Temperature)" + " F"
            windConditionView.conditionValueLabel.text = info.windSpeed + " [mph]"
            pressureConditionView.conditionValueLabel.text = info.pressure + " [psi]"
            break
        case .metric:
            currentTemperatureLabel.text = "\(info.current_Temperature)" + " °C"
            minTemperatureLabel.text = "\(info.min_Temperature)" + " °C"
            maxTemperatureLabel.text = "\(info.max_Temperature)" + " °C"
            windConditionView.conditionValueLabel.text = info.windSpeed + " [km/h]"
            pressureConditionView.conditionValueLabel.text = info.pressure + " [hPa]"
            break
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            switch locationManager.authorizationStatus {
            case .denied, .restricted, .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                locationManager.startUpdatingLocation()
                if let coordinates = locationManager.location?.coordinate,
                   UserDefaultsService.fetchUpdated().shouldShowUserLocationWeather {
                    let lat = coordinates.latitude
                    let lon = coordinates.longitude
                    viewModel.weatherSubject.send(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                }
                else {
                    let settings = UserDefaultsService.fetchUpdated()
                    viewModel.weatherSubject.send(CLLocationCoordinate2D(latitude: settings.lastLatitude, longitude: settings.lastLongitude))
                }
            }
        }
        else {
            showAlert(text: "Device location dissabled.\nUsing default weather info for Vienna location.") { }
        }
    }
    
    func returnToHomeScene(_ item: Geoname?) {
        dismiss(animated: true, completion: nil)
        searchTextField.resignFirstResponder()
        if let selectedCity = item { viewModel.update(selectedCity) }
    }
    
    func presentSearchScene() {
        let vm = SearchSceneViewModel(searchRepository: SearchRepositoryImpl())
        vm.delegate = self
        let vc = SearchSceneViewController(viewModel: vm)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension HomeSceneViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        presentSearchScene()
        return true
    }
}

extension HomeSceneViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            if let coordinate = locationManager.location?.coordinate {
                viewModel.weatherSubject.send(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last,
           UserDefaultsService.fetchUpdated().shouldShowUserLocationWeather {
            viewModel.weatherSubject.send(CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                 longitude: location.coordinate.longitude))
        }
    }
    
    func shouldShowUserLocation() -> Bool { return viewModel.shouldShowUserLocation() }
}

//MARK: CONSTRAINTS BELOW
extension HomeSceneViewController {
    
    func setConstraints() {
        setConstraintsBackgroundImage()
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
    
    func setConstraintsBackgroundImage() { backgroundImage.snp.makeConstraints { (make) in make.edges.equalTo(view) } }
    
    func setConstraintsOnCurrentTemperatureLabel() {
        currentTemperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(80)
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
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(30)
        }
    }
    
    func setConstraintsOnMinTemperatureLabel() {
        minTemperatureLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(30)
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
            make.height.equalTo(100)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(30)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraintsOnMaxTemperatureLabel() {
        maxTemperatureLabel.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(30)
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
            make.bottom.equalTo(searchTextField.snp.top).offset(-30)
        }
    }
    
    func setConstraintsOnSettingsButton() {
        settingsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.leading.equalTo(view.snp.leading).offset(10)
        }
        
    }
    
    func setConstraintsOnSearchTextField() {
        searchTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(settingsButton.snp.trailing).offset(30)
            make.height.equalTo(40)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
        }
        
    }
}
