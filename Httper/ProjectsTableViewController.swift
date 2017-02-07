//
//  ProjectsTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 30/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ProjectsTableViewController: UITableViewController {
    
    let dao = DaoManager.sharedInstance
    var projects: [Project] = []
    
    let sync = SyncManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Syncrhonize projects, pull remote projects and push local projects.
        syncProjects()
        // Initialize loading view.
        initLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        projects = dao.projectDao.findAll()
        self.tableView.reloadData()
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
        print("Project's physical id in server is \(project.pid)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectIdentifier", for: indexPath)
        let projectNameLabel = cell.viewWithTag(1) as! UILabel
        projectNameLabel.text = project.pname
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let project = projects[indexPath.row]
            // Remove project from table view.
            projects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Remove it from persistent store and server.
            sync.deleteProject(project, completionHandler: nil)
        }
    }
    
    // MARK: - Service
    func syncProjects() {
        // Pull remote projects from server
        sync.pullUpdatedProjects { (revision) in
            // Pull successfully.
            if revision > 0 {
                self.projects = self.dao.projectDao.findAll()
                self.tableView.reloadData()
                
                // Push local projects to server in background.
                self.sync.pushLocalProjects(nil)
            }
            // Stop loading.
            self.tableView.dg_stopLoading()
        }
    }

    func initLoadingView() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.lightGray
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.syncProjects()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(RGB(DesignColor.nagivation.rawValue))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
}
