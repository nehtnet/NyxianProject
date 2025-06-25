//
//  ButtonCell.swift
//  Nyxian
//
//  Created by FridaDEV on 15.05.25.
//

import UIKit

class ButtonTableCell: UITableViewCell {
    let title: String
    var button: UIButton?
    
    init(
        title: String
    ) {
        self.title = title
        super.init(style: .default, reuseIdentifier: nil)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Setting up the button
        button = UIButton()
        button?.titleLabel?.textAlignment = .left
        button?.contentHorizontalAlignment = .left
        button?.setTitle(self.title, for: .normal)
        button?.setTitleColor(UILabel.appearance().textColor, for: .normal)
        button?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(button!)
        
        // Now fix its constraints
        NSLayoutConstraint.activate([
            button!.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            button!.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            button!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            button!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
    }
}
