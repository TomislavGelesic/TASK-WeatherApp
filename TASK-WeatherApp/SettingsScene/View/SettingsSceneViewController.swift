//
//  SettingsSceneViewController.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit
import SnapKit
import Combine

class SettingsSceneViewController: UIViewController {
    
    var disposeBag = Set<AnyCancellable>()
    
    var viewModel: SettingsSceneViewModel
    
    let locationsLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "Locations"
        label.textAlignment = .center
        label.font = label.font.withSize(24)
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
        collectionView.backgroundColor = .clear
        collectionView.register(SavedLocationsCollectionViewCell.self, forCellWithReuseIdentifier: SavedLocationsCollectionViewCell.reuseIdentifier)
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        return collectionView
    }()
    
    let unitsLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "Units"
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        label.backgroundColor = .clear
        return label
    }()
    
    let unitsCheckBox: UnitsCheckBox = {
        let box = UnitsCheckBox()
        box.backgroundColor = .clear
        return box
    }()
    
    let conditionsLabelDescription: UILabel = {
        let label = UILabel()
        label.text = "Conditions"
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        label.backgroundColor = .clear
        return label
    }()
    
    let conditionsCheckBox: ConditionsCheckBox = {
        let box = ConditionsCheckBox()
        box.backgroundColor = .clear
        return box
    }()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("APPLY", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    
    init(viewModel: SettingsSceneViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
//        print("SettingsSceneViewController deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateBackgroundImage()
        setNavigationBar()
        setSubviews()
        setConstraints()
        setSubscribers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension SettingsSceneViewController {
    
    func setNavigationBar() {
                
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let backButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonPressed))
            button.tintColor = .black
            return button
        }()
        
        navigationItem.setLeftBarButton(backButton, animated: true)
        
        let rightButton: UIBarButtonItem = {
            let button = UIBarButtonItem(image: UIImage(systemName: "text.justify"),
                                         style: .plain,
                                         target: self,
                                         action: nil)
            button.tintColor = .black
            return button
        }()
        
        navigationItem.setRightBarButton(rightButton, animated: true)
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "SETTINGS"
            return label
        }()
        
        navigationItem.titleView = titleLabel
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setSubviews() {
        view.addSubviews([
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
        locationsCollectionView.reloadData()
        
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        viewModel.backButtonTapped()
    }
    
    @objc func applyButtonTapped() {
        viewModel.applyTapped(unitsCheckBox.getSelectedUnit())
    }
    
    func setSubscribers() {
        
        conditionsCheckBox.didSelectCondition
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (type) in
                print("\(type) updating")
                self.viewModel.conditionTapped(type)
            }
            .store(in: &disposeBag)
        
        viewModel.refreshUISubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (_) in
                
                self.locationsCollectionView.reloadData()
                
                self.unitsCheckBox.setActiveRadioButton(for: UserDefaultsService.fetchUpdated().measurmentUnit)
                
                if UserDefaultsService.fetchUpdated().shouldShowHumidity {
                    self.conditionsCheckBox.setActive(for: .humidity)
                }
                
                if UserDefaultsService.fetchUpdated().shouldShowPressure {
                    self.conditionsCheckBox.setActive(for: .pressure)
                }
                
                if UserDefaultsService.fetchUpdated().shouldShowWindSpeed {
                    self.conditionsCheckBox.setActive(for: .windSpeed)
                }
                
            }
            .store(in: &disposeBag)
    }
}

extension SettingsSceneViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.savedLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SavedLocationsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: viewModel.savedLocations[indexPath.row])
        cell.removeButtonAction = { [unowned self] in
            self.viewModel.remove(at: indexPath.row)
        }
        return cell
    }
}

extension SettingsSceneViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = locationsCollectionView.frame.width
        let cellHeight = CGFloat(30.0)
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension SettingsSceneViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewModel.didSelectSavedCity(wantedCity: indexPath.row, unitsCheckBox.getSelectedUnit())
    }
}



//MARK: CONSTRAINTS BELOW

extension SettingsSceneViewController {
    
    func setConstraints() {
        
        setConstraintsOnLocationsLabelDescription()
        setConstraintsOnLocationsCollectionView()
        setConstraintsOnUnitsLabelDescription()
        setConstraintsOnUnitsCheckBox()
        setConstraintsOnConditionsLabelDescription()
        setConstraintsOnConditionsCheckBox()
        setConstraintsOnApplyButton()
    }
    
    func setConstraintsOnLocationsLabelDescription() {
        
        locationsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(view).inset(UIEdgeInsets(top: getTopBarHeight(), left: 5, bottom: 0, right: 5))
            make.centerX.equalTo(view)
            make.height.equalTo(30)
            
        }
    }
    
    func setConstraintsOnLocationsCollectionView() {
        
        locationsCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.top.equalTo(locationsLabelDescription.snp.bottom)
            make.height.equalTo(view.frame.height/4)
        }
    }
    
    func setConstraintsOnUnitsLabelDescription() {
        
        unitsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(locationsCollectionView.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(20)
        }
    }
    
    func setConstraintsOnUnitsCheckBox() {
        
        unitsCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(unitsLabelDescription.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(60)
        }
    }
    
    func setConstraintsOnConditionsLabelDescription() {
        
        conditionsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(unitsCheckBox.snp.bottom).offset(20)
            make.centerX.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(20)
        }
    }
    
    func setConstraintsOnConditionsCheckBox() {
        
        conditionsCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsLabelDescription.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.bottom.equalTo(applyButton.snp.top).offset(-10)
        }
    }
    
    func setConstraintsOnApplyButton() {
        
        applyButton.snp.makeConstraints { (make) in
            make.width.equalTo(88)
            make.height.equalTo(44)
            make.bottom.trailing.equalTo(view).offset(-30)
        }
    }
}
