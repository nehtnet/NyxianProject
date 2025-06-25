//
//  SettingsViewController.swift
//  LindDE
//
//  Created by fridakitten on 09.05.25.
//

import UIKit

class SettingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: {
                if #available(iOS 16.0, *) {
                    return "wrench.adjustable.fill"
                } else {
                    return "gearshape.2.fill"
                }
            }())
            cell.textLabel?.text = "Toolchain"
            break
        case 1:
            cell.imageView?.image = UIImage(systemName: "paintbrush.fill")
            cell.textLabel?.text = "Customization"
            break
        case 2:
            cell.imageView?.image = UIImage(systemName: "tray.2.fill")
            cell.textLabel?.text = "Miscellaneous"
            break
        case 3:
            cell.imageView?.image = UIImage(systemName: "info")
            cell.textLabel?.text = "Info"
            break
        default:
            break
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController: UIViewController
        
        switch indexPath.row {
        case 0:
            viewController = ToolChainController(style: .insetGrouped)
            break
        case 1:
            viewController = CustomizationViewController(style: .insetGrouped)
            break
        case 2:
            viewController = MiscellaneousController(style: .insetGrouped)
            break
        case 3:
            viewController = AppInfoViewController(style: .insetGrouped)
            break
        default:
            viewController = UIViewController()
            break
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
