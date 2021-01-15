//
//  AvailableCitiesTableViewCell.swift
//  TASK-WeatherApp
//
//  Created by Tomislav Gelesic on 15.01.2021..
//

import UIKit
import SnapKit

class AvailableCitiesTableViewCell: UITableViewCell {

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "CITY XYZ".uppercased()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AvailableCitiesTableViewCell {
    
    func setup() {
        
        backgroundColor = .cyan
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
        }
    }
    
    func configure(with name: String) {
        
        label.text = name.uppercased()
    }
}
