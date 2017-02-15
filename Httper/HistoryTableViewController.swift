//
//  HistoryTableViewController.swift
//  Httper
//
//  Created by 李大爷的电脑 on 14/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import Alamofire
import DGElasticPullToRefresh

class HistoryTableViewController: UITableViewController {
    // Flag for this view controller.
    // If push is true, when user click a cell, push nagivation view controller to request view controller.
    // If push is false, pop nagivation view controller to project table view controller.
    var push = true
    
    let dao = DaoManager.sharedInstance
    let sync = SyncManager.sharedInstance
    
    var dateFormatter = DateFormatter()
    var requests :[Request]!
    var selectedRequest: Request!

    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        requests = dao.requestDao.findAll()
        
        syncRequests()
        initLoadingView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestIdentifier", for: indexPath)
        let urlLabel = cell.viewWithTag(1) as! UILabel
        let methodLabel = cell.viewWithTag(2) as! UILabel
        let updateLabel = cell.viewWithTag(3) as! UILabel
        let request = requests[indexPath.row]
        
//        NSLog("\(request.url!) revision = \(request.revision), rid = \(request.rid)")
        urlLabel.text = request.url
        methodLabel.text = request.method
        updateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(request.update)))
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if push {
            selectedRequest = requests[indexPath.row]
            _ = self.performSegue(withIdentifier: "historyRequestSegue", sender: self)
        } else {
            let length = self.navigationController?.viewControllers.count
            let controller = self.navigationController?.viewControllers[length! - 2]
            controller?.setValue(requests[indexPath.row], forKey: "request")
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete request entity.
            sync.deleteRequest(requests[indexPath.row], completionHandler: nil)
            // Delete the row from the data source
            requests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyRequestSegue" {
            segue.destination.setValue(selectedRequest, forKey: "request")
        }
    }
    
    // MARK: - Service
    func syncRequests() {
        // Pull new updated requests from server.
        sync.pullUpdatedRequests { (revision) in
            if revision > 0 {
                // Refresh table view
                self.requests = self.dao.requestDao.findAll()
                self.tableView.reloadData()
                
                // Push local requests to server.
                self.sync.pushLocalRequests(nil)
            }
            // Do not forget to call dg_stopLoading() at the end
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
