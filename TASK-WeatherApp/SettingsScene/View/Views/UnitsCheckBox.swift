//
//  CheckBox.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

class UnitsCheckBox: UIView {
    
    var radioButtons = [UnitsRadioButton]()
    
    var selectedUnit: MeasurementUnits = .metric

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UnitsCheckBoxTableViewCell.self, forCellReuseIdentifier: UnitsCheckBoxTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    init() {
        super.init(frame: .zero)
        
        setup()
        
        // order important because tag isn't used for 'selectedUnit' property
        radioButtons.append(UnitsRadioButton(description: "Metric", active: true, type: .metric))
        radioButtons.append(UnitsRadioButton(description: "Imperial", active: false, type: .imperial))
        tableView.reloadData()
    }
    
    required init(coder: NSCoder?) {
        fatalError()
    }
    
}

extension UnitsCheckBox {
    
    func setup() {
        addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setConstraints_tableView()
    }
    
    func setConstraints_tableView() {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func setActiveRadioButton(for type: MeasurementUnits) {
        
        for item in radioButtons {
            item.isActive = false
            
            if item.type == type {
                item.isActive = true
            }
        }
        
        tableView.reloadData()
    }
    
    func getSelectedUnit() -> MeasurementUnits {
        return selectedUnit
    }
    
    func setActiveRadioButton(for position: Int) {
        
        for item in radioButtons {
            item.isActive = false
        }
        
        switch position {
        case 1:
            selectedUnit = .imperial
            break
        case 0: 
            selectedUnit = .metric
            break
        default:
            print("POSITION OUT OF RANGE IN UnitsCheckBox.swift")
            break
        }
        radioButtons[position].isActive = true
        tableView.reloadData()
    }
}

extension UnitsCheckBox: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioButtons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UnitsCheckBoxTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.configure(with: radioButtons[indexPath.row])
        
        return cell
    }
}

extension UnitsCheckBox: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setActiveRadioButton(for: indexPath.row)
    }
}
