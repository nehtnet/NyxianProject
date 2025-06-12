//
//  ImportCell.swift
//  Nyxian
//
//  Created by FridaDEV on 16.05.25.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

class ImportTableCell: UITableViewCell, UIDocumentPickerDelegate {
    private let parent: UIViewController
    private var button: UIButton?
    private var label: UILabel?
    private(set) var url: URL?
    
    init(
        parent: UIViewController
    ) {
        self.parent = parent
        super.init(style: .default, reuseIdentifier: nil)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Setup the button
        self.button = UIButton()
        self.button?.titleLabel?.textAlignment = .left
        self.button?.contentHorizontalAlignment = .left
        self.button?.setTitle("Import", for: .normal)
        self.button?.setTitleColor(UIColor.systemBlue, for: .normal)
        self.button?.translatesAutoresizingMaskIntoConstraints = false
        self.button?.addAction(UIAction { _ in
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .pageSheet
            self.parent.present(documentPicker, animated: true)
        }, for: .touchUpInside)
        self.contentView.addSubview(self.button!)

        // Setup the label
        self.label = UILabel()
        self.label!.translatesAutoresizingMaskIntoConstraints = false
        self.button!.addSubview(self.label!)

        // Constraints
        NSLayoutConstraint.activate([
            self.button!.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.button!.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.button!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.button!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),

            self.label!.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.label!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
        
        self.label!.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else { return }
        
        self.url = selectedURL
        
        print("Picked file: \(selectedURL.lastPathComponent)")
        
        UIView.animate(withDuration: 0.25) {
            self.label!.alpha = 0.0
        } completion: { _ in
            
            self.label!.text = selectedURL.lastPathComponent
            
            UIView.animate(withDuration: 0.25) {
                self.label!.alpha = 1.0
            }
        }
    }
}
