//
//  CustomizationViewController.swift
//  Zeus
//
//  Created by fridakitten on 12.05.25.
//

import UIKit
import Runestone

class CustomizationViewController: UITableViewController {
    var textField: UITextField?
    
    var icons: [String] = [
        "Default",
        "Drawn",
        "MoonLight"
    ]
    
    var themePreviewCell: ThemePickerPreviewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Customization"
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Credentials"
        case 1:
            return "Themes"
        case 2:
            return "Icons"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return (indexPath.row == 0) ? 150 : 44
        case 2:
            return 65
        default:
            return 44
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1;
        case 2:
            return self.icons.count;
        default:
            return 2;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            cell = TextFieldTableCell(title: "Username", key: "LDEUsername", defaultValue: "Anonym")
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                themePreviewCell = ThemePickerPreviewCell()
                cell = themePreviewCell!
                (cell as! ThemePickerPreviewCell).populate(with: ThemePickerPreviewCell.ViewModel(theme: getCurrentSelectedTheme(), text: """
#include <stdio.h>

int main(void)
{
\tprintf(\"Hello, World\\n\");
\treturn 0;
}
"""))
            } else {
                cell = PickerTableCell(options: ["NyxianLDE", "Solarized"], title: "Theme", key: "LDETheme", defaultValue: 0)
                (cell as! PickerTableCell).callback = { selected in
                    self.themePreviewCell!.switchTheme(theme: themes[selected])
                    restartProcess()
                }
            }
        } else {
            cell = UITableViewCell()
            let iconName = icons[indexPath.row]
            if let image = UIImage(named: {
                if #available(iOS 18.0, *) {
                    return "IconPreview\(iconName)"
                } else {
                    return "IconPreview\(iconName)Old"
                }
            }()) {
                let customImageView = UIImageView(image: image)
                customImageView.layer.cornerRadius = 10
                customImageView.layer.masksToBounds = true
                customImageView.translatesAutoresizingMaskIntoConstraints = false
                customImageView.contentMode = .scaleAspectFit
                cell.contentView.addSubview(customImageView)
                
                NSLayoutConstraint.activate([
                    customImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    customImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    customImageView.widthAnchor.constraint(equalToConstant: 50),
                    customImageView.heightAnchor.constraint(equalToConstant: 50)
                ])
            }
            
            cell.textLabel?.text = iconName
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cell.textLabel!.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                cell.textLabel!.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 80) // room for image
            ])
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 2 else { return }
        
        let iconName: String = self.icons[indexPath.row]
        
        if iconName == "Default" {
            UIApplication.shared.setAlternateIconName(nil)
            return
        }
        
        UIApplication.shared.setAlternateIconName(iconName)
    }
}
