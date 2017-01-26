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

    func pullUpdatedRequest(_ completionHandler: ((Int) -> Void)?) {
        let localRevision = requestRevision()
        let params: Parameters = [
            "revision": localRevision
        ]
        Alamofire.request(createUrl("api/request/pull"),
                          method: HTTPMethod.get,
                          parameters: params,
                          encoding: URLEncoding.default,
                          headers: tokenHeader())
        .responseJSON { (responseObject) in
            let response = InternetResponse(responseObject)
            if response.statusOK() {
                let result = response.getResult()
                let revision = result?["revision"] as! Int
                if revision <= localRevision {
                    return
                }
                
                let updatedRequests = result?["updated"] as! [[String: Any]]
                // Save updated requests to persistent store
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
            }
        }
    }
    
}
