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
    
    let dao = DaoManager.sharedInstance
    let sync = SyncManager.sharedInstance
    
    var dateFormatter = DateFormatter()
    var requests :[Request]!

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
        print("\(request.url!) revision = \(request.revision), rid = \(request.rid)")
        urlLabel.text = request.url
        methodLabel.text = request.method
        updateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(request.update)))
        return cell
    }
    
    /**
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default,
                                                title: NSLocalizedString("delete_name", comment: ""),
                                                handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
        })
        deleteButton.backgroundColor = RGB(PrettyColor.key.rawValue)
        return [deleteButton]
    }
    */

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let length = self.navigationController?.viewControllers.count
        let controller = self.navigationController?.viewControllers[length! - 2]
        controller?.setValue(requests[indexPath.row], forKey: "request")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let request = requests[indexPath.row]
            let rid = request.rid
            dao.requestDao.delete(request)
            requests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete this request in server
            if rid == nil {
                return
            }
            let params: Parameters = [
                "rid": rid!
            ]
            Alamofire.request(createUrl("api/request/push"),
                              method: HTTPMethod.delete,
                              parameters: params,
                              encoding: URLEncoding.default,
                              headers: tokenHeader())
            .responseJSON(completionHandler: { (responseObject) in
                let response = InternetResponse(responseObject)
                if response.statusOK() {
                    // Update local request revision by the revision from server.
                    let revision = response.getResult()["revision"] as! Int
                    updateRequestRevision(revision)
                }
            })
        } 
    }
    
    // MARK: - Service
    func syncRequests() {
        // Pull new updated request from server.
        sync.pullUpdatedRequests { (revision) in
            // Refresh table view
            self.requests = self.dao.requestDao.findAll()
            self.tableView.reloadData()
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
