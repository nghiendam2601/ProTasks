//
//  RealmManager.swift
//  Pro Tasks
//
//  Created by DamMinhNghien on 27/7/24.
//

import Foundation
import RealmSwift

class RealmManager {
    //MARK: - Properties
    static let shared = RealmManager()
    private var realm: Realm
    
    //MARK: - Initialize
    private init() {
        do {
            realm = try Realm()
            try! realm.write{
            }
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    //MARK: - GetAllTask
    func getAllTask() -> Results<Task>{
        return realm.objects(Task.self)
    }
    
    //MARK: - AddTask
    func addTask(task: Task){
        try! realm.write{
            realm.add(task)
            
        }
    }
    //MARK: - DeleteTask
    func deleteTask(id: String){
        if let taskToDelete = realm.object(ofType: Task.self, forPrimaryKey: id) {
            try! realm.write{
                realm.delete(taskToDelete)
            }
        }
    }
    func getTask(ID: String) -> Task{
        let task = getAllTask().where{
            $0.id == ID
        }
        return task.first!
        
    }
    
    //MARK: - Setup data for CollectionView
    func getDayTasks(date: Date) -> Results<Task>{
        //        return getAllTask().dueDate.contains(date...date.endOfDay)
        return getAllTask().filter("dueDate BETWEEN %@", startEndDateArray(forDate: date))
    }
    fileprivate func startEndDateArray(forDate: Date) -> [Date] {
        return [forDate, forDate.endOfDay]
    }
    
    //MARK: - IsCompletedTask
    func getIsCompletedTasks(Id: String) -> Bool{
        let task = getAllTask().where{
            $0.id == Id
        }
        return task.first!.isCompleted
    }
    func updateIsCompletedTasks(Id: String){
        let task = getAllTask().where{
            $0.id == Id
        }
        try! realm.write{
            task.first!.isCompleted.toggle()
        }
    }
    
    //MARK: - DueTask
    func updateDueDateTask(Id: String,newDueDate: Date){
        let task = getAllTask().where{
            $0.id == Id
        }
        try! realm.write{
            task.first!.dueDate = newDueDate
        }
    }
    func getDueDateTask(Id:String) -> Date{
        let task = getAllTask().where{
            $0.id == Id
        }
        return task.first!.dueDate
    }

    //MARK: - Title/NoteTask
    func updateTask(Id: String,Title: String,Node:String){
        let task = getAllTask().where{
            $0.id == Id
        }
        try! realm.write{
            task.first!.title = Title
            task.first!.note = Node
        }
    }
    //MARK: - Setup data for TableView
    func getDatesWithTasks() -> [Date] {
        
        let tasks = realm.objects(Task.self)
        
        var datesWithTasks = Set<Date>()
        
        for task in tasks {
            if task.dueDate.startOfDay >= Date().startOfDay {
                
                datesWithTasks.insert(task.dueDate.startOfDay)
            }else{
                deleteTask(id: task.id)
            }
        }
        return datesWithTasks.sorted()
        
    }
    
}
