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

class RequestDao: NSObject {
    
    private var delegate: AppDelegate!
    
    override init() {
        delegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    func saveOrUpdate(method: String, url: String, headers: HTTPHeaders, parameters: Parameters, bodytype: String, body: NSData?) -> Request {
        let request = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Request.self),
                                                                   into: delegate.managedObjectContext) as! Request
        request.method = method
        request.url = url
        request.headers = NSKeyedArchiver.archivedData(withRootObject: headers) as NSData?
        request.parameters = NSKeyedArchiver.archivedData(withRootObject: parameters) as NSData?
        request.bodytype = bodytype
        request.body = body
        request.update = Int64(NSDate().timeIntervalSince1970)
        delegate.saveContext()
        return request
    }
    
    func findAll() -> [Request] {
        let fetchRequest = NSFetchRequest<Request>(entityName: NSStringFromClass(Request.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "update", ascending: false)]
        return try! delegate.managedObjectContext.fetch(fetchRequest)
    }

    func delete(_ deleteRequest: Request) {
        delegate.managedObjectContext.delete(deleteRequest)
        delegate.saveContext()
    }
}
