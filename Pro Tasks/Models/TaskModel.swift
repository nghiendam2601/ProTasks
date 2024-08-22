//
//  TaskModel.swift
//  Pro Tasks
//
//  Created by DamMinhNghien on 19/7/24.
//

import Foundation
import RealmSwift


class Task: Object{
    //MARK: - Properties
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var dueDate: Date = Date()
    @Persisted var note: String = ""
    @Persisted var isCompleted: Bool = false
    
    //MARK: - Initialize
    convenience init(title: String, dueDate: Date, note: String, isCompleted: Bool) {
        self.init()
        self.title = title
        self.dueDate = dueDate
        self.note = note
        self.isCompleted = isCompleted
    }
    
}
//MARK: - Enum
enum ActionTask{
    case add
    case edit
}



