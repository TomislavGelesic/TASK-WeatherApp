//
//  CheckBox.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 14.01.2021..
//

import UIKit

class UnitsCheckBox: UIView {
    
    weak var delegate: UnitsCheckBoxDelegate?
    
    var radioButtons = [UnitsRadioButton]()

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
    
    func setActiveRadioButton(position: Int) {
        
        for item in radioButtons {
            item.isActive = false
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
        
        setActiveRadioButton(position: indexPath.row)
        
        delegate?.itemSelected(type: radioButtons[indexPath.row].type)
    }
}
