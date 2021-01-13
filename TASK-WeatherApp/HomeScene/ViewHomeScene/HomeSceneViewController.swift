//
//  HomeSceneViewController.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 13.01.2021..
//

import UIKit
import SnapKit

class HomeSceneViewController: UIViewController {
    
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
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let conditionsFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
    
    let conditionsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = false
        collectionView.register(ConditionsHomeSceneCollectionViewCell.self, forCellWithReuseIdentifier: ConditionsHomeSceneCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.2.fill")?.withTintColor(.black), for: .normal)
        button.setImage(UIImage(systemName: "gearshape.2")?.withTintColor(.black), for: .selected)
        return button
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.black))
        textField.leftViewMode = .always
        textField.placeholder = "Search"
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addSubviews()
        setConstraints()
        
        setupConditionsCollectionView()
    }
    
}
extension HomeSceneViewController {
    
    func setupConditionsCollectionView() {
        
        conditionsCollectionView.collectionViewLayout = conditionsFlowLayout
        conditionsCollectionView.delegate = self
        conditionsCollectionView.dataSource = self
        
    }
}

extension HomeSceneViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConditionsHomeSceneCollectionViewCell.reuseIdentifier, for: indexPath)
        
        return cell
    }
    
    
}

extension HomeSceneViewController: UICollectionViewDelegate {
    
}

extension HomeSceneViewController {
    
    func addSubviews() {
        
        view.backgroundColor = .lightGray
        
        view.addSubviews([
           currentTemperatureLabel,
           weatherDescriptionLabel,
           cityNameLabel,
           conditionsCollectionView,
           minTemperatureLabel,
           minTemperatureLabelDescription,
           verticalLine,
           maxTemperatureLabel,
           maxTemperatureLabelDescription,
           settingsButton,
           searchTextField])
    }
    
    func setConstraints() {
        
        setConstraints_currentTemperatureLabel()
        setConstraints_weatherDescriptionLabel()
        setConstraints_cityNameLabel()
        setConstraints_minTemperatureLabel()
        setConstraints_minTemperatureLabelDescription()
        setConstraints_verticalLine()
        setConstraints_maxTemperatureLabel()
        setConstraints_maxTemperatureLabelDescription()
        setConstraints_conditionsCollectionView()
        setConstraints_settingsButton()
        setConstraints_searchTextField()
    }
    
    func setConstraints_currentTemperatureLabel() {
        currentTemperatureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(10)
            make.width.height.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraints_weatherDescriptionLabel() {
        weatherDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(currentTemperatureLabel.snp.bottom).offset(10)
            make.width.equalTo(view.frame.width/2)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraints_cityNameLabel() {
        cityNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(weatherDescriptionLabel.snp.bottom).offset(50)
            make.width.equalTo(view.frame.width / 2)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraints_minTemperatureLabel() {
        minTemperatureLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.trailing.equalTo(verticalLine.snp.leading).offset(-15)
        }
    }
    
    func setConstraints_minTemperatureLabelDescription() {
        minTemperatureLabelDescription.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.bottom.equalTo(verticalLine.snp.bottom).offset(-10)
            make.top.equalTo(minTemperatureLabel.snp.bottom).offset(10)
            make.trailing.equalTo(verticalLine.snp.leading).offset(-15)
        }
    }
    
    func setConstraints_verticalLine() {
        verticalLine.snp.makeConstraints { (make) in
            make.width.equalTo(2)
            make.height.equalTo(90)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraints_maxTemperatureLabel() {
        maxTemperatureLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(verticalLine.snp.trailing).offset(15)
        }
    }
    
    func setConstraints_maxTemperatureLabelDescription() {
        maxTemperatureLabelDescription.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.bottom.equalTo(verticalLine.snp.bottom).offset(-10)
            make.top.equalTo(maxTemperatureLabel.snp.bottom).offset(10)
            make.leading.equalTo(verticalLine.snp.trailing).offset(15)
        }
    }
    
    func setConstraints_conditionsCollectionView() {
        conditionsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(verticalLine.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(settingsButton.snp.top).offset(-5)
            #warning("add collectionViewFlowLayout sizeForItemAt")
            #warning("collection view height")
        }
    }
    
    func setConstraints_settingsButton() {
        settingsButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(44)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(10)
        }
        
    }
    
    func setConstraints_searchTextField() {
        searchTextField.snp.makeConstraints { (make) in
            make.width.equalTo(view.frame.width - 44 - 30)
            make.height.equalTo(44)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
            make.bottom.equalTo(view.snp.bottom)
        }
        
    }
    
}
