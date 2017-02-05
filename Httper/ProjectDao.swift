//
//  ProjectDao.swift
//  Httper
//
//  Created by 李大爷的电脑 on 01/02/2017.
//  Copyright © 2017 limeng. All rights reserved.
//

import CoreData

class ProjectDao: DaoTemplate {
    
    func save(pname: String, privilege: String, introduction: String) -> Project {
        let project = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Project.self),
                                                          into: context) as! Project
        project.pname = pname;
        project.privilege = privilege;
        project.introduction = introduction;
        project.update = Int64(NSDate().timeIntervalSince1970)
        self.saveContext()
        return project;
    }
    
    func syncUpdated(_ projectObject: [String: Any]) {
        let project = NSEntityDescription.insertNewObject(forEntityName: NSStringFromClass(Project.self),
                                                          into: context) as! Project
        project.pname = projectObject["pname"] as? String
        project.privilege = projectObject["privilege"] as? String
        project.introduction = projectObject["introduction"] as? String
        project.update = projectObject["updateAt"] as! Int64
        // Save physical id from server.
        project.pid = projectObject["rid"] as? String
        // Save revision
        project.revision = projectObject["revision"] as! Int16
        self.saveContext()
    }

    func findAll() -> [Project] {
        let fetchRequest = NSFetchRequest<Project>(entityName: NSStringFromClass(Project.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "pname", ascending: false)]
        return try! context.fetch(fetchRequest)
    }

    func findUnsynced() -> [Project] {
        let fetchRequest = NSFetchRequest<Project>(entityName: NSStringFromClass(Project.self))
        fetchRequest.predicate = NSPredicate(format: "revision=0 and pid=nil")
        return try! context.fetch(fetchRequest)
    }

    func findInPids(_ pids: [String]) -> [Project] {
        let fetchRequest = NSFetchRequest<Project>(entityName: NSStringFromClass(Project.self))
        fetchRequest.predicate = NSPredicate(format: "pid IN %@", pids);
        return try! context.fetch(fetchRequest)
    }
    
    func delete(_ deleteProject: Project) {
        context.delete(deleteProject)
        self.saveContext()
    }
}
