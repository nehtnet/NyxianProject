//
//  LoggerViewController.swift
//  LindDE
//
//  Created by fridakitten on 09.05.25.
//

import Foundation
import UIKit

class LoggerTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.backgroundColor = UITableView.appearance().backgroundColor
        self.textColor = UILabel.appearance().textColor
        self.font = UIFont.monospacedSystemFont(ofSize: 10, weight: .bold)
        self.isEditable = false
        self.isSelectable = true
        
        self.text = LDELogger.log
    }
    
    convenience init() {
        self.init(frame: .zero, textContainer: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LoggerViewController: UIViewController {
    let loggerText: LoggerTextView = LoggerTextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        self.title = "Console"
        
        self.loggerText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loggerText)

        NSLayoutConstraint.activate([
            self.loggerText.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.loggerText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loggerText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.loggerText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
