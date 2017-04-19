//
//  ProjectTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 07/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

let attributeImgaes = ["tab_project", "privilege"]

class ProjectTableViewController: UITableViewController {
    
    var project: Project!
    var selectedRequest: Request!
    
    let dao = DaoManager.sharedInstance
    let sync = SyncManager.sharedInstance

    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncRequests()
        initLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = project.pname
        // Update table view.
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show tab bar.
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 30))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return project.requests!.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: "projectIdentifier", for: indexPath)
                let projectLabel = cell.viewWithTag(2) as! UILabel
                projectLabel.text = project.pname
            } else if indexPath.row == 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: "privilegeIdentifier", for: indexPath)
                let privilegeLabel = cell.viewWithTag(2) as! UILabel
                privilegeLabel.text = project.privilege
            } else if indexPath.row == 2 {
                cell = tableView.dequeueReusableCell(withIdentifier: "introductionIdentifier", for: indexPath)
                let introductionLabel = cell.viewWithTag(2) as! UILabel
                introductionLabel.text = project.introduction
            }
            cell = UITableViewCell()
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "requestIdentifier", for: indexPath)
            let urlLabel = cell.viewWithTag(1) as! UILabel
            let methodLabel = cell.viewWithTag(2) as! UILabel
            let request = project.requests?[indexPath.row] as! Request
            urlLabel.text = request.url
            methodLabel.text = request.method
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "projectNameSegue", sender: self)
            case 1:
                break
            case 2:
                self.performSegue(withIdentifier: "introductionSegue", sender: self)
            default:
                break
            }
        } else if indexPath.section == 1 {
            selectedRequest = project.requests?[indexPath.row] as! Request!
            self.performSegue(withIdentifier: "projectRequestSegue", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if editingStyle == .delete {
                let deletedRequest = project.requests?[indexPath.row] as! Request
                // Remove it from persistent store and server.
                sync.deleteRequest(deletedRequest, completionHandler: nil)
                // Remove request from table view.
                project.removeFromRequests(deletedRequest)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    @IBAction func deleteRequestFromProject(_ sender: UIButton) {
        let cell: UITableViewCell = (sender as UIView).superview?.superview as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)!
        let url = (cell.viewWithTag(1) as! UILabel).text!
        let method = (cell.viewWithTag(2) as! UILabel).text!
        let message = NSLocalizedString("delete_request_confirm", comment: "") + url + "(" + method + ")"
        let alertController = UIAlertController(title: NSLocalizedString("tip_name", comment: ""),
                                                message: message,
                                                preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("cancel_name", comment: ""),
                                   style: .cancel,
                                   handler: nil)
        let confirm = UIAlertAction(title: NSLocalizedString("ok_name", comment: ""),
                                    style: .destructive) { (action) in
            let deletedRequest = self.project.requests?[indexPath.row] as! Request
            // Remove it from persistent store and server.
            self.sync.deleteRequest(deletedRequest, completionHandler: nil)
            // Remove request from table view.
            self.project.removeFromRequests(deletedRequest)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectHistorySegue" {
            // Pop history view controller to this view controller.
            segue.destination.setValue(false, forKey: "push")
        } else if segue.identifier == "projectRequestSegue" {
            segue.destination.setValue(selectedRequest, forKey: "request")
        } else if segue.identifier == "projectNameSegue" {
            segue.destination.setValue(project, forKey: "project")
        } else if segue.identifier == "introductionSegue" {
            segue.destination.setValue(project, forKey: "project")
        }
    }

    
    // MARK: - Service
    func addRequest(_ request: Request) {
        // Add request to project at local persistent store.
        project.addToRequests(request)
        
        // Push this request to server.
        // Set this request's revision to 0 at first, only request with revision 0 can be pushed to remote server.
        request.revision = 0;
        // Save persistent store context.
        dao.saveContext()
        // User SyncManger to push request
        sync.pushLocalRequests(nil)
    }
    
    func syncRequests() {
        // Pull new updated requests from server.
        sync.pullUpdatedRequests { (revision) in
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
        }
    }
    
    // Initialize loading view
    func initLoadingView() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.lightGray
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            self?.syncRequests()
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(RGB(DesignColor.nagivation.rawValue))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }

}
