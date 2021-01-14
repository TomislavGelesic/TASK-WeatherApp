//
//  SettingsSceneViewController.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit
import SnapKit

class SettingsSceneViewController: UIViewController {
    
    let savedLocations = ["test 1", "test 2", "test 3"]
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "body_image-clear-day")
        return imageView
    }()
    
    let locationsLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "Locations"
        label.textAlignment = .center
        label.font = label.font.withSize(26)
        label.backgroundColor = .clear
        return label
    }()
    
    let locationsFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        return layout
    }()
    
    let locationsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .red
        collectionView.register(SavedLocationsCollectionViewCell.self, forCellWithReuseIdentifier: SavedLocationsCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    let unitsLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "Units"
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    let unitsCheckBox: UnitsCheckBox = {
        let box = UnitsCheckBox()
        box.backgroundColor = .blue
        return box
    }()
    
    let conditionsLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "Conditions"
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    let conditionsCheckBox: ConditionsCheckBox = {
        let box = ConditionsCheckBox()
        box.backgroundColor = .green
        return box
    }()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("APPLY", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setSubviews()
        setConstraints()
    }
    
    
}

extension SettingsSceneViewController {
    
    func setNavigationBar() {
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        
        navigationController?.navigationBar.standardAppearance = coloredAppearance
        navigationController?.navigationBar.compactAppearance = coloredAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = coloredAppearance
        
        let backButton: UIBarButtonItem = {
            let buttonImage = UIImage(systemName: "chevron.backward")
            let button = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonPressed))
            button.tintColor = .black
            return button
        }()
        
        navigationItem.setLeftBarButton(backButton, animated: true)
        
        let rightButton: UIBarButtonItem = {
            let buttonImage = UIImage(systemName: "text.justify")
            let button = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(backButtonPressed))
            button.tintColor = .black
            return button
        }()
        
        navigationItem.setRightBarButton(rightButton, animated: true)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "settings".uppercased()
            return label
        }()
        
        navigationItem.titleView = titleLabel
    }
    
    @objc func backButtonPressed() {
        
        navigationController?.popViewController(animated: true)
    }
    
    func setSubviews() {
        view.addSubviews([
            backgroundImageView,
            locationsLabelDescription,
            locationsCollectionView,
            unitsLabelDescription,
            unitsCheckBox,
            conditionsLabelDescription,
            conditionsCheckBox,
            applyButton
        ])
        
        locationsCollectionView.dataSource = self
        locationsCollectionView.delegate = self
        locationsCollectionView.collectionViewLayout = locationsFlowLayout
    }
    
    func setConstraints() {
        
        setConstraints_backgroundImageView()
        setConstraints_locationsLabelDescription()
        setConstraints_locationsCollectionView()
//        setConstraints_unitsLabelDescription()
//        setConstraints_unitsCheckBox()
//        setConstraints_conditionsLabelDescription()
//        setConstraints_conditionsCheckBox()
//        setConstraints_applyButton()
    }
    
    func setConstraints_backgroundImageView() {
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setConstraints_locationsLabelDescription() {
        locationsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(view).inset(UIEdgeInsets(top: getTopBarHeight(), left: 0, bottom: 0, right: 0))
            make.centerX.equalTo(view)
            
        }
    }
    
    func setConstraints_locationsCollectionView() {
        
        locationsCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(locationsLabelDescription.snp.bottom)
        }
    }
    
    func setConstraints_unitsLabelDescription() {
        
        unitsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(locationsCollectionView.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    func setConstraints_unitsCheckBox() {
        
        unitsCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(unitsLabelDescription.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view)
        }
    }
    
    func setConstraints_conditionsLabelDescription() {
        
        conditionsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(unitsCheckBox.snp.bottom).offset(10)
            make.centerX.equalTo(view)
        }
    }
    
    func setConstraints_conditionsCheckBox() {
        
        conditionsCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsLabelDescription.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view)
        }
    }
    
    func setConstraints_applyButton() {
        
        applyButton.snp.makeConstraints { (make) in
            make.width.equalTo(88)
            make.height.equalTo(44)
            make.bottom.trailing.equalTo(view).offset(-10)
        }
    }
}

extension SettingsSceneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SavedLocationsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: savedLocations[indexPath.row])
        return cell
    }
    
    
    
}

extension SettingsSceneViewController: UICollectionViewDelegate {
    
}
