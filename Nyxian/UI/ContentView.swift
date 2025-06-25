//
//  ContentView.swift
//  LindDE
//
//  Created by lindsey on 05.05.25.
//

import Foundation
import UIKit

class ContentViewController: UITableViewController {
    var projects: [AppProject] = []
    var path: String
    
    var lastProjectWasSelected: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "LDELastProjectSelectedEven")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LDELastProjectSelectedEven")
        }
    }
    var lastProjectSelected: String {
        get {
            return UserDefaults.standard.string(forKey: "LDELastProjectSelected") ?? "0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LDELastProjectSelected")
        }
    }
    var cellSelected: Int = 0
    
    @objc init(path: String) {
        RevertUI()
        
        Bootstrap.shared.bootstrap()
        LDELogger.setup()
        CertBlob.startSigner()
        
        self.path = path
        
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Projects"
        
        let barbutton: UIBarButtonItem = UIBarButtonItem()
        barbutton.image = UIImage(systemName: "plus")
        barbutton.target = self
        barbutton.action = #selector(PlusTabbed)
        self.navigationItem.setRightBarButton(barbutton, animated: false)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.rowHeight = 70
        
        self.projects = AppProject.listProjects(ofPath: self.path)
        
        self.tableView.reloadData()
        
        if lastProjectWasSelected {
            let selectedProject = AppProject(path: "\(self.path)/\(lastProjectSelected)")
            
            let fileVC = FileListViewController(project: selectedProject,
                                                path: selectedProject.getPath())
            
            self.navigationController?.pushViewController(fileVC, animated: false)
            
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lastProjectWasSelected = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.projects[indexPath.row].projectTableCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedProject = projects[indexPath.row]
        let fileVC = FileListViewController(project: selectedProject,
                                            path: selectedProject.getPath())
        self.navigationController?.pushViewController(fileVC, animated: true)
        
        self.cellSelected = indexPath.row
        lastProjectSelected = selectedProject.getUUID()
        lastProjectWasSelected = true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let project = self.projects[indexPath.row]
            
            let alert: UIAlertController = UIAlertController(
                title: "Warning",
                message: "Are you sure you want to remove \"\(project.projectConfig.displayname)\"?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
                AppProject.removeProject(project: project)
                self.projects = AppProject.listProjects(ofPath: self.path)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func PlusTabbed() {
        let alert = UIAlertController(title: "Create Project",
                                      message: "",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "Name"
        }
        
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "Bundle Identifier"
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let createAction: UIAlertAction = UIAlertAction(title: "Create", style: .default) { action -> Void in
            let name = (alert.textFields![0]).text!
            let bundleid = (alert.textFields![1]).text!
            
            self.projects.append(AppProject.createAppProject(
                atPath: self.path,
                executable: name,
                bundleid: bundleid
            ))
            
            let newIndexPath = IndexPath(row: self.projects.count - 1, section: 0)
            
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        self.present(alert, animated: true)
    }
}
