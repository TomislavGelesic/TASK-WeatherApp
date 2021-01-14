//
//  ConditionsCheckBox.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit
import SnapKit

class ConditionsCheckBox: UIView {
    
    weak var delegate: UnitsCheckBoxDelegate?
    
    var radioButtons = [ConditionsRadioButton]()
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        return layout
    }()

    let conditionsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(ConditionsCheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: ConditionsCheckBoxCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setup()
        createRadioButtons()
        conditionsCollectionView.reloadData()
    }
    
    required init(coder: NSCoder?) {
        fatalError()
    }
    
}

extension ConditionsCheckBox {
    
    func setup() {
        
        addSubview(conditionsCollectionView)
        
        conditionsCollectionView.dataSource = self
        conditionsCollectionView.delegate = self
        conditionsCollectionView.collectionViewLayout = flowLayout
        
        setConstraints_tableView()
    }
    
    func setConstraints_tableView() {
        
        conditionsCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func createRadioButtons() {
        
        if let image = UIImage(named: "humidity_icon") {
            radioButtons.append(ConditionsRadioButton(image: image, isChecked: false, type: .humidity))
        }
        if let image = UIImage(named: "pressure_icon") {
            radioButtons.append(ConditionsRadioButton(image: image, isChecked: false, type: .wind))
        }
        if let image = UIImage(named: "wind_icon") {
            radioButtons.append(ConditionsRadioButton(image: image, isChecked: false, type: .pressure))
        }
    }
}

extension ConditionsCheckBox: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return radioButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ConditionsCheckBoxCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let image = radioButtons[indexPath.row].image {
            cell.configure(with: image)
        }
        return cell
    }
    
    
    
    
}

extension ConditionsCheckBox: UICollectionViewDelegate {
    
    
}



