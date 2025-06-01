//
//  Project+Debug.swift
//  Nyxian
//
//  Created by SeanIsTethered on 29.05.25.
//

import Foundation
import UIKit

/*
 * Debug "tile" in UI
 *
 */
class DebugItem: Codable {
    enum DebugServerity: UInt8, Codable {
        case Note = 0
        case Warning = 1
        case Error = 2
    }
    
    let severity: DebugItem.DebugServerity
    let message: String     // in case of it being a file it contains the error, in case of it being a message it contains the message it self
    let line: UInt64        // in case of it being a file it contains at what line the error is
    let column: UInt64      // in case of it being a file it contains at what column the error is, this and the previous variable is ignored in case of it being a DebugMessage
    
    init(severity: DebugItem.DebugServerity, message: String, line: UInt64, column: UInt64) {
        self.severity = severity
        self.message = message
        self.line = line
        self.column = column
    }
}

/*
 * Content of one thing (i.e file/blah)
 *
 */
class DebugObject: Codable {
    enum DebugObjectType: Codable {
        case DebugFile
        case DebugMessage
    }
    
    let title: String       // in case of it being a file it contains the last path component, in case of it being a message it contains "Internal"
    let type: DebugObject.DebugObjectType
    var debugItems: [DebugItem] = []
    
    init(title: String, type: DebugObject.DebugObjectType) {
        self.title = title
        self.type = type
    }
}

/*
 * Content of debug file (i.e `debug.json`)
 *
 */
class DebugDatabase: Codable {
    var debugObjects: [String:DebugObject] = [:]
    
    /*
     * Function that gets the database of a filepath
     */
    static func getDatabase(ofPath path: String) -> DebugDatabase {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let blob = try decoder.decode(DebugDatabase.self, from: data)
            return blob
        } catch {
            print("Failed to decode certblob:", error)
            // MARK: If it doesnt exist we create one
            let debugDatabase: DebugDatabase = DebugDatabase()
            
            debugDatabase.debugObjects["Internal"] = DebugObject(title: "Internal", type: .DebugMessage)
            
            // First object is reserved for internal
            return debugDatabase
        }
    }
    
    /*
     * Function that saves the database to a filepath
     */
    func saveDatabase(toPath path: String) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let jsonData = try? encoder.encode(self) {
                try jsonData.write(to: URL(fileURLWithPath: path))
            }
        } catch {
            // TODO: Handle error
        }
    }
    
    /*
     * Functions to manage object entries
     */
    func addInternalMessage(message: String, severity: DebugItem.DebugServerity) {
        guard let internalObject = self.debugObjects["Internal"] else { return }
        internalObject.debugItems.append(DebugItem(severity: severity, message: message, line: 0, column: 0))
    }
    
    func setFileDebug(ofPath path: String, synItems: [Synitem]) {
        // TODO: Last path component is pretty ineffective if the user has files with the same name at a other location in the project
        let fixedPath: String = path.trimmingPathToFirstUUID().trimmingPathToFirstUUID()
        let fileObject: DebugObject = DebugObject(title: fixedPath, type: .DebugFile)
        
        for item in synItems {
            let debugItem: DebugItem = DebugItem(severity: DebugItem.DebugServerity(rawValue: item.type) ?? .Note, message: item.message, line: item.line, column: item.column)
            fileObject.debugItems.append(debugItem)
        }
        
        self.debugObjects[fixedPath] = (synItems.count > 0) ? fileObject : nil
    }
    
    func getFileDebug(ofPath path: String) -> [Synitem] {
        var synItems: [Synitem] = []
        
        // Get object
        let fixedPath: String = path.trimmingPathToFirstUUID().trimmingPathToFirstUUID()
        let fileObject: DebugObject = DebugObject(title: fixedPath, type: .DebugFile)
        
        for item in fileObject.debugItems {
            let synItem: Synitem = Synitem()
            synItem.type = item.severity.rawValue
            synItem.message = item.message
            synItem.line = item.line
            synItem.column = item.column
            synItems.append(synItem)
        }
        
        return synItems
    }
    
    func removeFileDebug(ofPath path: String) {
        let lastPathComponent: String = URL(fileURLWithPath: path).lastPathComponent
        self.debugObjects[lastPathComponent] = nil
    }
    
    func clearDatabase() {
        self.debugObjects = [:]
        self.debugObjects["Internal"] = DebugObject(title: "Internal", type: .DebugMessage)
    }
    
    func reuseDatabase() {
        self.debugObjects["Internal"] = DebugObject(title: "Internal", type: .DebugMessage)
    }
}

extension String {
    func removingUUIDs() -> String {
        let pattern = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
        return self.replacingOccurrences(of: pattern, with: "UUID", options: .regularExpression)
    }
    
    func trimmingPathToFirstUUID() -> String {
        let components = self.components(separatedBy: "/")
        let uuidPattern = #"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"#
        
        var foundUUID = false
        var trimmedComponents: [String] = []
        
        for component in components {
            if foundUUID {
                trimmedComponents.append(component)
            } else if component.range(of: uuidPattern, options: .regularExpression) != nil {
                foundUUID = true // Start including from next component
            }
        }
        
        return foundUUID ? trimmedComponents.joined(separator: "/") : nil ?? "UNKNOWN"
    }
}

/*
 * Debug UI: Issue Navigator and Database at the same time that will be shared over the entire project :3
 *
 */
class UIDebugViewController: UITableViewController {
    let file: String
    var debugDatabase: DebugDatabase
    
    var sortedDebugObjects: [DebugObject] {
        return debugDatabase.debugObjects.values.sorted {
            if $0.title == "Internal" {
                return true
            } else if $1.title == "Internal" {
                return false
            } else {
                return $0.title < $1.title
            }
        }
    }
    
    init(project: AppProject) {
        self.file = "\(project.getCachePath().1)/debug.json"
        self.debugDatabase = DebugDatabase.getDatabase(ofPath: self.file)
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Issue Navigator"
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        /*let buttonBar: UIBarButtonItem = UIBarButtonItem()
        buttonBar.tintColor = .label
        buttonBar.title = "Clear"
        buttonBar.target = self
        buttonBar.action = #selector(clearDatabase)
        self.navigationItem.setRightBarButton(buttonBar, animated: false)*/
        
        let testButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(clearDatabase))
        testButton.tintColor = UIColor.systemRed
        /*let testButton = UIButton(type: .system)
        testButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        testButton.addTarget(self, action: #selector(clearDatabase), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: testButton)*/
        self.navigationItem.rightBarButtonItem = testButton
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = sortedDebugObjects[section].debugItems.count
        return (count > 0) ? count : 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sortedDebugObjects[section].title) - \(sortedDebugObjects[section].debugItems.count)"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDebugObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = sortedDebugObjects[indexPath.section].debugItems
        let item = (items.count > 0) ? items[indexPath.row] : DebugItem(severity: .Note, message: "Contains no messages", line: 0, column: 0)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = item.message
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        let tintColor: UIColor = {
            switch item.severity {
            case .Note:
                return UIColor.systemBlue
            case .Warning:
                return UIColor.systemOrange
            case .Error:
                return UIColor.systemRed
            }
        }()
        
        let symbolName: String = {
            switch item.severity {
            case .Note:
                return "info.circle.fill"
            case .Warning:
                return "exclamationmark.triangle.fill"
            case .Error:
                return "xmark.octagon.fill"
            }
        }()
        
        cell.contentView.backgroundColor = tintColor.withAlphaComponent(0.6)
        
        // The stripe where we will place the SFSymbol later on
        let stripeView: UIView = UIView()
        stripeView.backgroundColor = tintColor
        stripeView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image View
        let configuration: UIImage.SymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 8.0)
        let image: UIImage? = UIImage(systemName: symbolName, withConfiguration: configuration)
        let imageView: UIImageView = UIImageView(image: image)
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stripeView.addSubview(imageView)
        
        cell.contentView.addSubview(stripeView)
        
        // Setting the constraints how we wanna layout our views
        NSLayoutConstraint.activate([
            stripeView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            stripeView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            stripeView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            stripeView.widthAnchor.constraint(equalToConstant: 20),
            
            cell.textLabel!.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            cell.textLabel!.leadingAnchor.constraint(equalTo: stripeView.trailingAnchor, constant: 10),
            cell.textLabel!.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            
            cell.contentView.heightAnchor.constraint(equalTo: cell.textLabel!.heightAnchor, constant: 20),
            
            imageView.centerYAnchor.constraint(equalTo: stripeView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: stripeView.centerXAnchor)
        ])
        
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false
        
        return cell
    }
    
    @objc func clearDatabase() {
        debugDatabase.clearDatabase()
        debugDatabase.saveDatabase(toPath: self.file)
        tableView.reloadData()
    }
}
