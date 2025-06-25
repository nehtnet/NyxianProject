//
//  PickerCell.swift
//  Nyxian
//
//  Created by FridaDEV on 15.05.25.
//

import Foundation
import UIKit

class PickerTableCell: UITableViewCell {
    let title: String
    
    let options: [String]
    let key: String
    let defaultValue: Int
    var callback: (Int) -> Void = { _ in }
    var value: Int {
        get {
            if UserDefaults.standard.object(forKey: self.key) == nil {
                UserDefaults.standard.set(self.defaultValue, forKey: self.key)
            }
            
            return UserDefaults.standard.integer(forKey: self.key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.key)
            callback(newValue)
        }
    }
    private var selectedOption: String {
        get {
            return self.options[self.value]
        }
        set {
            self.value = options.firstIndex(where: { $0 == newValue } ) ?? 0
        }
    }
    
    init(
        options: [String],
        title: String,
        key: String,
        defaultValue: Int
    ) {
        self.options = options
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
        
        // create the chevron image
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let image: UIImage = UIImage(systemName: "chevron.up.chevron.down", withConfiguration: config)!
        
        // now the option button
        let button: UIButton = UIButton()
        button.setTitle(self.selectedOption, for: .normal)
        button.setTitleColor(UILabel.appearance().textColor, for: .normal)
        button.setImage(image, for: .normal)
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        button.titleLabel?.textAlignment = .right
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(button)
        
        // now the menu for the button
        var menuItems: [UIMenuElement] = []
        
        for option in self.options {
            menuItems.append(UIAction(title: option) { _ in
                // get index
                let index = self.options.firstIndex(where: { $0 == option } )
                
                // update value
                self.value = index ?? 0
                
                // update title
                button.setTitle(self.selectedOption, for: .normal)
            })
        }
        
        button.menu = UIMenu(children: menuItems)
        button.showsMenuAsPrimaryAction = true
        
        // Now fix its constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            
            button.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
    }
}
