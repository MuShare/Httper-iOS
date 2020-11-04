//
//  SyncManager.swift
//  Httper
//
//  Created by lidaye on 25/01/2017.
//  Copyright © 2017 MuShare Group. All rights reserved.
//

import Alamofire
import SwiftyUserDefaults

final class SyncManager {
    
    var dao: DaoManager!
    
    static let shared = SyncManager()
    
    init() {
        dao = DaoManager.shared
    }
    
    func syncAll() {
        // Pull projects at first, then pull request from server.
        pullUpdatedProjects { (revision) in
            self.pullUpdatedRequests(nil)
        }
        // Push local projects, then push local requests.
        pushLocalProjects { (revision) in
            self.pushLocalRequests(nil)
        }
    }

    func pullUpdatedRequests(_ completionHandler: ((Int) -> Void)?) {
        let localRevision = requestRevision()
        let params: Parameters = [
            "revision": localRevision
        ]
        AF.request(
            createUrl("api/request/pull"),
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = Response($0)
            if response.statusOK() {
                let result = response.getResult()
                let revision = result["revision"].intValue
                if revision <= localRevision {
                    completionHandler?(revision)
                    return
                }
                
                let updatedRequests = result["updated"].arrayValue
                // Save updated requests to persistent store.
                for requestObject in updatedRequests {
                    // Check pid, if pid is not nil, try to find a project and add this request to the project.
                    let pid = requestObject["pid"].string
                    if pid == nil {
                        continue
                    }
                    let project = self.dao.projectDao.getByPid(pid!)
                    if (project == nil) {
                        continue
                    }
                    // Add this request to project.
                    _ = self.dao.requestDao.syncUpdated(requestObject, project: project!)
                }
                
                // Delete requests in deleted id list.
                var deletedRids: [String] = []
                for object in result["deleted"].arrayValue {
                    deletedRids.append(object.stringValue)
                }
                for request in self.dao.requestDao.findInRids(deletedRids) {
                    self.dao.requestDao.delete(request)
                }
                
                // Update local request revision
                updateRequestRevision(revision)
                // Completion hander
                completionHandler?(revision)
            } else {
                completionHandler?(-1)
            }
        }
    }
    
    func pushLocalRequests(_ completionHandler: ((Int) -> Void)? = nil) {
        let requests = dao.requestDao.findUnsynced()
        if requests.count == 0 {
            return
        }
        var requestArray = [[String: Any]]()
        for request in requests {
            var headers: StorageHttpHeaders? = nil, parameters: Parameters? = nil
            var body = ""
            if let requestHeaders = request.headers {
                headers = NSKeyedUnarchiver.unarchiveObject(with: requestHeaders as Data) as? StorageHttpHeaders
            }
            if let requestParameters = request.parameters {
                parameters = NSKeyedUnarchiver.unarchiveObject(with: requestParameters as Data) as? Parameters
            }
            if let requestBody = request.body {
                body = String(data: requestBody as Data, encoding: .utf8)!
            }
  
            // Add request object to request array.
            requestArray.append([
                "url": request.url!,
                "method": request.method!,
                "updateAt": request.update,
                "headers": JSONStringWithObject(headers!)!,
                "parameters": JSONStringWithObject(parameters!)!,
                "bodyType": request.bodytype!,
                "body": body,
                // If rid is not nil, that means this request entity has been synced with server before.
                // This time, we are going to update this request entity, rather than create a new one.
                "rid": request.rid ?? "",
                // If pid is not nil, that menas this request has been added to a project.
                "pid": request.project?.pid ?? ""
            ])
        }
        let params: Parameters = [
            "requestsJSONArray": JSONStringWithObject(requestArray)!
        ]
        AF.request(
            createUrl("api/request/push"),
            method: .post,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = Response($0)
            if response.statusOK() {
                let dataResult = response.getResult()
                let results = dataResult["results"]
                for i in 0 ..< requests.count {
                    let result = results[i]
                    let request = requests[i]
                    request.rid = result["rid"].stringValue
                    request.revision = result["revision"].int16Value
                }
                self.dao.saveContext()
                
                let revision = dataResult["revision"].intValue
                // Update local request revision
                updateRequestRevision(revision)
                // Completion
                completionHandler?(revision)
            } else {
                // If push failed, completion with -1.
                completionHandler?(-1)
            }
        }
    }
    
    // Delete a request in persistent store and server.
    func deleteRequest(_ request: Request, completion: ((Int) -> Void)? = nil) {
        // If rid is nil or token is nil, that means this request cannot sync with server
        // Just delete this request entity in local persistent store.
        guard let rid = request.rid, token() != nil else {
            dao.requestDao.delete(request)
            dao.saveContext()
            completion?(0)
            return
        }
        let params: Parameters = [
            "rid": rid
        ]
        AF.request(
            createUrl("api/request/push"),
            method: HTTPMethod.delete,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = Response($0)
            if response.statusOK() {
                // Update local request revision by the revision from server.
                let revision = response.getResult()["revision"].intValue
                updateRequestRevision(revision)
                // Delete local request entity.
                self.dao.requestDao.delete(request)
                self.dao.saveContext()
                // Completion
                completion?(revision)
            } else {
                switch response.errorCode() {
                case .tokenError:
                    // Delete local request entity if token is error,
                    // that means this entity cannot map with any entity in server.
                    self.dao.managedObjectContext.delete(request)
                    self.dao.saveContext()
                default:
                    break
                }
                completion?(-1)
            }
        }

    }
    
    // Pull projects from server.
    // Return newest revision in completionHandler
    func pullUpdatedProjects(_ completionHandler: ((Int) -> Void)?) {
        let localRevision = projectRevision()
        let params: Parameters = [
            "revision": localRevision
        ]
        AF.request(
            createUrl("api/project/pull"),
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = Response($0)
            if response.statusOK() {
                let result = response.getResult()
                let revision = result["revision"].intValue
                if revision <= localRevision {
                    completionHandler?(revision)
                    return
                }
                let updatedProjects = result["updated"].arrayValue
                // Save updated projects to persistent store.
                for project in updatedProjects {
                    self.dao.projectDao.syncUpdated(project)
                }
                // Delete projects in deleted id list.
                var deletedPids: [String] = []
                for object in result["deleted"].arrayValue {
                    deletedPids.append(object.stringValue)
                }
                for project in self.dao.projectDao.findInPids(deletedPids) {
                    self.dao.projectDao.delete(project)
                }
                // Update local project revision
                updateProjectRevision(revision)
                // Complete
                completionHandler?(revision)
            } else {
                // Pull failed.
                completionHandler?(-1)
            }
        }
    }

    // Push local projects to server.
    // Return newest revision in completionHandler
    func pushLocalProjects(_ completion: ((Int) -> Void)?) {
        let projects = dao.projectDao.findUnsynced()
        if projects.count == 0 {
            completion?(0)
            return
        }
        let projectArray: [[String: Any]] = projects.filter {
            $0.pname != nil && $0.privilege != nil && $0.introduction != nil
        }.map {
            [
                "pname": $0.pname!,
                "privilege": $0.privilege!,
                "introduction": $0.introduction!,
                "updateAt": $0.update,
                "pid": $0.pid ?? ""
            ]
        }
        guard let projectsJSONArray = JSONStringWithObject(projectArray) else {
            completion?(0)
            return
        }
        
        let params: Parameters = [
            "projectsJSONArray": projectsJSONArray
        ]
        AF.request(
            createUrl("api/project/push"),
            method: .post,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON {
            let response = Response($0)
            if response.statusOK() {
                let dataResult = response.getResult()
                let results = dataResult["results"]
                for i in 0 ..< projects.count {
                    let result = results[i]
                    let project = projects[i]
                    project.pid = result["pid"].stringValue
                    project.revision = result["revision"].int16Value
                }
                self.dao.saveContext()
                
                let revision = dataResult["revision"].intValue
                // Update local request revision
                updateProjectRevision(revision)
                // Completion
                completion?(revision)
            } else {
                // If push failed, completion with -1.
                completion?(-1)
            }
        }
    }
    
    // Delete project in persistent store and server.
    func deleteProject(_ project: Project, completion: ((Int) -> Void)? = nil) {
        // If this project entity is not sync with server, just delete it in local persistent store.
        guard let pid = project.pid, token() != nil else {
            dao.managedObjectContext.delete(project)
            dao.saveContext()
            completion?(0)
            return
        }
        let params: Parameters = [
            "pid": pid
        ]
        AF.request(
            createUrl("api/project/push"),
            method: .delete,
            parameters: params,
            encoding: URLEncoding.default,
            headers: tokenHeader()
        ).responseJSON { [weak self] in
            guard let `self` = self else {
                return
            }
            let response = Response($0)
            if response.statusOK() {
                // Update local project revision by the revision from server.
                let revision = response.getResult()["revision"].intValue
                updateProjectRevision(revision)
                // Delete local project entity.
                self.dao.managedObjectContext.delete(project)
                self.dao.saveContext()
                // Completion
                completion?(revision)
            } else {
                switch response.errorCode() {
                case .tokenError:
                    // Delete local project entity if token is error,
                    // that means this entity cannot map with any entity in server.
                    self.dao.managedObjectContext.delete(project)
                    self.dao.saveContext()
                default:
                    break
                }
                completion?(-1)
            }
        }
    }

    
}
