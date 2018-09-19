//
//  SelectProjectTableViewController.swift
//  Httper
//
//  Created by Meng Li on 19/04/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import UIKit

class SelectProjectTableViewController: UITableViewController {

    let dao = DaoManager.shared
    var projects: [Project] = []
    var selectedProject: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        projects = dao.projectDao.findAll()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectIdentifier", for: indexPath)
        let projectNameLabel = cell.viewWithTag(1) as! UILabel
        projectNameLabel.text = project.pname
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainController = self.navigationController?.viewControllers[0] as! MainViewController
        if let controller = mainController.selectedViewController, controller.isKind(of: RequestViewController.self) {
            let requestViewController = controller as! RequestViewController
            requestViewController.saveToProject = projects[indexPath.row]
            navigationController?.popViewController(animated: true)
        }
    }
}
