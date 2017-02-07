//
//  RequestDao.swift
//  Httper
//
//  Created by 李大爷的电脑 on 14/12/2016.
//  Copyright © 2016 limeng. All rights reserved.
//

import CoreData
import Alamofire

class RequestDao: DaoTemplate {
    
    func saveOrUpdate(rid: String?, update: Int64?, revision: Int16?, method: String, url: String, headers: HTTPHeaders, parameters: Parameters, bodytype: String, body: NSData?) -> Request {
        var request: Request? = nil
        if rid != nil {
            request = self.getByRid(rid!)
        }
        if request == nil {
            request = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Request.self),
                                                          into: context) as? Request
        }
        request?.method = method
        request?.url = url
        request?.headers = NSKeyedArchiver.archivedData(withRootObject: headers) as NSData?
        request?.parameters = NSKeyedArchiver.archivedData(withRootObject: parameters) as NSData?
        request?.bodytype = bodytype
        request?.body = body
        // Set rid if it is not nil
        if rid != nil {
            request?.rid = rid
        }
        request?.update = (update == nil) ? Int64(NSDate().timeIntervalSince1970) : update!
        request?.revision = (revision == nil) ? 0 : revision!
        self.saveContext()
        return request!
    }
    
    func syncUpdated(_ requestObject: [String: Any]) {
        let body = requestObject["body"] as! String
        _ = self.saveOrUpdate(rid: requestObject["rid"] as? String,
                              update: requestObject["updateAt"] as? Int64,
                              revision: requestObject["revision"] as? Int16,
                              method: (requestObject["method"] as? String)!,
                              url: (requestObject["url"] as? String)!,
                              headers: serializeJSON(requestObject["headers"] as! String) as! HTTPHeaders,
                              parameters: serializeJSON(requestObject["parameters"] as! String)! as Parameters,
                              bodytype: (requestObject["bodyType"] as? String)!,
                              body: NSData.init(data: body.data(using: .utf8)!))
    }
    
    func findAll() -> [Request] {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "update", ascending: false)]
        return try! context.fetch(fetchRequest)
    }
    
    func findRevisionLargerThan(_ revision: Int) -> [Request] {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.predicate = NSPredicate(format: "revision>%d", revision)
        return try! context.fetch(fetchRequest)
    }
    
    func findByRevision(_ revision: Int) -> [Request] {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.predicate = NSPredicate(format: "revision=%d", revision)
        return try! context.fetch(fetchRequest)
    }
    
    func findUnsynced() -> [Request] {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.predicate = NSPredicate(format: "revision=0 and rid=nil")
        return try! context.fetch(fetchRequest)
    }
    
    func findInRids(_ rids: [String]) -> [Request] {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.predicate = NSPredicate(format: "rid IN %@", rids);
        //        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
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
