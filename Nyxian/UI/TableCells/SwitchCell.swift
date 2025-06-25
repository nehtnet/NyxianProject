//
//  SwitchCell.swift
//  Nyxian
//
//  Created by FridaDEV on 15.05.25.
//

import Foundation
import UIKit

class SwitchTableCell: UITableViewCell {
    let title: String
    
    let key: String
    let defaultValue: Bool
    var value: Bool {
        get {
            if UserDefaults.standard.object(forKey: self.key) == nil {
                UserDefaults.standard.set(self.defaultValue, forKey: self.key)
            }
            
            return UserDefaults.standard.bool(forKey: self.key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
        }
    }
    
    init(
        title: String,
        key: String,
        defaultValue: Bool
    ) {
        self.title = title
        self.key = key
        self.defaultValue = defaultValue
        super.init(style: .default, reuseIdentifier: nil)
        
        _ = self.value
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // disable selection
        self.selectionStyle = .none
        
        // First create the label
        let label: UILabel = UILabel()
        label.text = self.title
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        
        // now the option button
        let toggle: UISwitch = UISwitch()
        toggle.onTintColor = UILabel.appearance().textColor
        toggle.thumbTintColor = UITableViewCell.appearance().backgroundColor
        toggle.setOn(self.value, animated: false)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        self.contentView.addSubview(toggle)
        
        // Now fix its constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            
            toggle.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16),
            toggle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
    @objc private func toggleValueChanged(_ sender: UISwitch) {
        self.value = sender.isOn
    }
}
