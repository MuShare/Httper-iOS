//
//  ProjectsViewController.swift
//  Httper
//
//  Created by Meng Li on 2018/7/4.
//  Copyright © 2018 MuShare Group. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class ProjectsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dao = DaoManager.shared
    var projects: [Project] = []
    var selectedProject: Project!
    
    let sync = SyncManager()
    
    var viewModel: ProjectsViewModel!
    
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
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.projectsViewController.projectSegue.identifier:
            let destination = segue.destination as! ProjectTableViewController
            destination.project = selectedProject
        default:
            break
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
        tableView.dg_setPullToRefreshFillColor(UIColor(hex: DesignColor.nagivation.rawValue))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

}

extension ProjectsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        //        print("Project's physical id in server is \(project.pid)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectIdentifier", for: indexPath)
        let projectNameLabel = cell.viewWithTag(1) as! UILabel
        projectNameLabel.text = project.pname
        return cell
    }
    
}

extension ProjectsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = projects[indexPath.row]
        self.performSegue(withIdentifier: R.segue.projectsViewController.projectSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove it from persistent store and server.
            sync.deleteProject(projects[indexPath.row], completionHandler: nil)
            // Remove project from table view.
            projects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

