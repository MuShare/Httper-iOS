//
//  SyncManager.swift
//  Httper
//
//  Created by lidaye on 25/01/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import Foundation
import Alamofire

class SyncManager: NSObject {
    
    var dao: DaoManager!
    
    static let sharedInstance : SyncManager = {
        let instance = SyncManager()
        return instance
    }()
    
    override init() {
        dao = DaoManager.sharedInstance
    }

    
    func pullUpdatedRequests(_ completionHandler: ((Int) -> Void)?) {
        let localRevision = requestRevision()
        let params: Parameters = [
            "revision": localRevision
        ]
        Alamofire.request(createUrl("api/request/pull"),
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let result = response.getResult()
                let revision = result?["revision"] as! Int
//                print("revision = \(revision) localRevision = \(localRevision)")
                if revision <= localRevision {
                    completionHandler?(revision)
                    return
                }
                
                let updatedRequests = result?["updated"] as! [[String: Any]]
                // Save updated requests to persistent store.
                for request in updatedRequests {
                    self.dao.requestDao.syncUpdated(request)
                }
                
                // Delete requests in deleted id list.
                let deletedRids = result?["deleted"] as! [String]
                for request in self.dao.requestDao.findInRids(deletedRids) {
                    self.dao.requestDao.delete(request)
                }
                
                // Update local request revision
                updateRequestRevision(revision)
                
                // Completion hander
                completionHandler?(revision)
                self.pushLocalRequests()
            } else {
                completionHandler?(-1)
            }
        }
    }
    
    func pushLocalRequests() {
        let requests = dao.requestDao.findUnsynced()
        if requests.count == 0 {
            return
        }
        var requestArray = [[String: Any]]()
        for request in requests {
            var headers: HTTPHeaders? = nil, parameters: Parameters? = nil
            var body = ""
            if request.headers != nil {
                headers = NSKeyedUnarchiver.unarchiveObject(with: request.headers! as Data) as? HTTPHeaders
            }
            if request.parameters != nil {
                parameters = NSKeyedUnarchiver.unarchiveObject(with: request.parameters! as Data) as? Parameters
            }
            if request.body != nil {
                body = String(data: request.body! as Data, encoding: .utf8)!
            }
            requestArray.append([
                "url": request.url!,
                "method": request.method!,
                "updateAt": request.update,
                "headers": JSONStringWithObject(headers!)!,
                "parameters": JSONStringWithObject(parameters!)!,
                "bodyType": request.bodytype!,
                "body": body,
            ])
        }
        let params: Parameters = [
            "requestsJSONArray": JSONStringWithObject(requestArray)!
        ]
        Alamofire.request(createUrl("api/request/push/list"),
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let dataResult = response.getResult()
                let results = dataResult?["results"] as! [[String: Any]]
                for i in 0 ..< requests.count {
                    let result = results[i]
                    let request = requests[i]
                    request.rid = result["rid"] as? String
                    request.revision = Int16(result["revision"] as! Int)
                }
                self.dao.saveContext()
                // Update local request revision
                updateRequestRevision(dataResult?["revision"] as! Int)
            }
        }
    }
    
    func pullUpdatedProjects(_ completionHandler: ((Int) -> Void)?) {
        let localRevision = projectRevision()
        let params: Parameters = [
            "revision": localRevision
        ]
        Alamofire.request(createUrl("api/project/pull"),
                          method: .get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let result = response.getResult()
                let revision = result?["revision"] as! Int
                if revision <= localRevision {
                    completionHandler?(revision)
                    return
                }
                let updatedProjects = result?["updated"] as! [[String: Any]]
                // Save updated projects to persistent store.
                for project in updatedProjects {
                    self.dao.projectDao.syncUpdated(project)
                }
                // Delete projects in deleted id list.
                let deletedPids = result?["deleted"] as! [String]
                for project in self.dao.projectDao.findInPids(deletedPids) {
                    self.dao.projectDao.delete(project)
                }
                // Update local project revision
                updateProjectRevision(revision)
                // Complete
                completionHandler?(revision)
                self.pushLocalProjects()
            }
        }
    }

    func pushLocalProjects() {
        let projects = dao.projectDao.findUnsynced()
        if projects.count == 0 {
            return
        }
        var projectArray: [[String: Any]] = []
        for project in projects {
            projectArray.append([
                "pname": project.pname!,
                "privilege": project.privilege!,
                "introduction": project.introduction!,
                "updateAt": project.update
            ]);
        }
        let params: Parameters = [
            "projectsJSONArray": JSONStringWithObject(projectArray)!
        ]
        Alamofire.request(createUrl("api/project/push"),
                          method: .post,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let dataResult = response.getResult()
                let results = dataResult?["results"] as! [[String: Any]]
                for i in 0 ..< projects.count {
                    let result = results[i]
                    let project = projects[i]
                    project.pid = result["pid"] as? String
                    project.revision = Int16(result["revision"] as! Int)
                }
                self.dao.saveContext()
                // Update local request revision
                updateProjectRevision(dataResult?["revision"] as! Int)
            }
        }
    }
    
}
