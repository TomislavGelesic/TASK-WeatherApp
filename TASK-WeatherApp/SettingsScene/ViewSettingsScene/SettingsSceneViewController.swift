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
    
    var coordinator: SettingsSceneCoordinator
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "body_image-clear-day")
        return imageView
    }()
    
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
    
    
    
    init(coordinator: SettingsSceneCoordinator, viewModel: SettingsSceneViewModel) {
        
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("SettingsSceneViewController deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setSubviews()
        setConstraints()
        setSubscribers()
        
        viewModel.refreshUISubject.send()
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
                                         action: #selector(backButtonPressed))
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
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func backButtonPressed() {
        
        coordinator.returnToHomeScene()
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
        locationsCollectionView.reloadData()
        
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc func applyButtonTapped() {
        
        viewModel.saveUserSettings()
        
        coordinator.returnToHomeScene()
    }
    
    func setSubscribers() {
        
        viewModel.refreshUISubject
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink { [unowned self] (settings) in
                
                self.locationsCollectionView.reloadData()
                
                self.unitsCheckBox.setActiveRadioButton(for: settings.measurmentUnit)
                
                if settings.shouldShowHumidity {
                    self.conditionsCheckBox.setActive(for: .humidity)
                }
                
                if settings.shouldShowPressure {
                    self.conditionsCheckBox.setActive(for: .pressure)
                }
                
                if settings.shouldShowWindSpeed {
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

extension SettingsSceneViewController: UICollectionViewDelegate { }



//MARK: CONSTRAINTS BELOW

extension SettingsSceneViewController {
    
    func setConstraints() {
        
        setConstraintsOnBackgroundImageView()
        setConstraintsOnLocationsLabelDescription()
        setConstraintsOnLocationsCollectionView()
        setConstraintsOnUnitsLabelDescription()
        setConstraintsOnUnitsCheckBox()
        setConstraintsOnConditionsLabelDescription()
        setConstraintsOnConditionsCheckBox()
        setConstraintsOnApplyButton()
    }
    
    func setConstraintsOnBackgroundImageView() {
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
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
            make.height.equalTo(view.frame.height/5)
        }
    }
    
    func setConstraintsOnUnitsLabelDescription() {
        
        unitsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(locationsCollectionView.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(20)
        }
    }
    
    func setConstraintsOnUnitsCheckBox() {
        
        unitsCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(unitsLabelDescription.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(60)
        }
    }
    
    func setConstraintsOnConditionsLabelDescription() {
        
        conditionsLabelDescription.snp.makeConstraints { (make) in
            make.top.equalTo(unitsCheckBox.snp.bottom).offset(5)
            make.centerX.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            make.height.equalTo(20)
        }
    }
    
    func setConstraintsOnConditionsCheckBox() {
        
        conditionsCheckBox.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsLabelDescription.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
    }
    
    func setConstraintsOnApplyButton() {
        
        applyButton.snp.makeConstraints { (make) in
            make.top.equalTo(conditionsCheckBox.snp.bottom).offset(5)
            make.width.equalTo(88)
            make.height.equalTo(44)
            make.bottom.trailing.equalTo(view).offset(-10)
        }
    }
}
