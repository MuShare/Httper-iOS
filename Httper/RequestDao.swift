//
//  RequestDao.swift
//  Httper
//
//  Created by 李大爷的电脑 on 14/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class RequestDao: DaoTemplate {
    
    func saveOrUpdate(method: String, url: String, headers: HTTPHeaders, parameters: Parameters, bodytype: String, body: NSData?) -> Request {
        let request = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Request.self),
                                                                   into: context) as! Request
        request.method = method
        request.url = url
        request.headers = NSKeyedArchiver.archivedData(withRootObject: headers) as NSData?
        request.parameters = NSKeyedArchiver.archivedData(withRootObject: parameters) as NSData?
        request.bodytype = bodytype
        request.body = body
        request.update = Int64(NSDate().timeIntervalSince1970)
        self.saveContext()
        return request
    }
    
    func syncUpdated(_ requestObject: [String: Any]) {
        if requestObject["deleted"] as! Bool {
            let request = getByRid((requestObject["rid"] as? String)!)
            if request != nil {
                context.delete(request!)
            }
        } else {
            let request = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Request.self),
                                                              into: context) as! Request
            request.method = requestObject["method"] as? String
            request.url = requestObject["url"] as? String
            let headers = serializeJSON(requestObject["headers"] as! String) as! HTTPHeaders
            let parameters = serializeJSON(requestObject["parameters"] as! String)! as Parameters
            request.headers = NSKeyedArchiver.archivedData(withRootObject: headers) as NSData?
            request.parameters = NSKeyedArchiver.archivedData(withRootObject: parameters) as NSData?
            request.bodytype = requestObject["bodyType"] as? String
            let body = requestObject["body"] as! String
            request.body = NSData.init(data: body.data(using: .utf8)!)
            request.update = requestObject["updateAt"] as! Int64
            // Save physical id from server.
            request.rid = requestObject["rid"] as? String
            // Save revision
            request.revision = requestObject["revision"] as! Int16
        }
        self.saveContext()
    }
    
    func findAll() -> [Request] {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "update", ascending: false)]
        return try! context.fetch(fetchRequest)
    }

    func delete(_ deleteRequest: Request) {
        context.delete(deleteRequest)
        self.saveContext()
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        try! context.persistentStoreCoordinator?.execute(deleteRequest, with: context)
    }
    
    func getByRid(_ rid: String) -> Request? {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.predicate = NSPredicate(format: "rid=%@", rid)
        let requests = try! context.fetch(fetchRequest)
        if requests.count == 0 {
            return nil
        }
        return requests[0]
    }
}
