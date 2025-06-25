//
//  AppInfo.swift
//  Nyxian
//
//  Created by SeanIsTethered on 23.06.25.
//

import Foundation
import UIKit

// App
let buildName: String = "Nightsky"
let buildStage: String = "Alpha"
let buildVersion: String = "0.3"

// Toolchain
let buildChainName: String = "Leaf"
let buildChainStage: String = "Alpha"
let buildChainVersion: String = "0.2"

// AppInfoView
class AppInfoViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Info"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return "Nyxian"
        } else if section == 2 {
            return "NyxianCore"
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? 120 : tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .value1, reuseIdentifier: "")
        
        if(indexPath.section == 0) {
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            
            let image: UIImage = UIImage(imageLiteralResourceName: "InfoThumbnail")
            let imageView: UIImageView = UIImageView(image: image)
            imageView.layer.cornerRadius = 15
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            
            cell.contentView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: 100),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                imageView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
            ])
        } else {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = (indexPath.section == 1) ? buildName : buildChainName
            case 1:
                cell.textLabel?.text = "Version"
                cell.detailTextLabel?.text = (indexPath.section == 1) ? buildVersion : buildChainVersion
            default:
                cell.textLabel?.text = "Stage"
                cell.detailTextLabel?.text = (indexPath.section == 1) ? buildStage : buildChainStage
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
