//
//  AddTaskViewController.swift
//  Pro Tasks
//
//  Created by DamMinhNghien on 25/7/24.
//

import UIKit
import RealmSwift

class ActionTaskViewController: UIViewController{
    //MARK: - IBOutlet
    @IBOutlet var dateAndTime: UIDatePicker!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var deleteLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var noteTextView: UITextView!
    
    //MARK: - Properties
    var ActionTask: ActionTask?
    var delegate: ReloadDelegate?
    var delegatePOP: PopToRootController?
    var id: String?
    let center = UNUserNotificationCenter.current()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        //MARK: Cancel Button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,  target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        //        navigationItem.titleView?.tintColor = .white
        
        //MARK: Setup DatePicker
        dateAndTime.minimumDate = Date()
        //        dateAndTime.setValue(UIColor.red, forKeyPath: "textColor")
        
        titleTextField.layer.borderColor = UIColor(named: "Color 1")?.cgColor
        titleTextField.layer.borderWidth = 2
        
        if let actionTask = ActionTask {
            switch actionTask{
                //MARK: Setup Edit Task
            case .edit:
                titleTextField.removeFromSuperview()
                textView.removeFromSuperview()
                titleLabel.removeFromSuperview()
                noteLabel.removeFromSuperview()
                
                //MARK: Setup Save Button
                let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneButtonTapped))
                navigationItem.rightBarButtonItem = saveButton
                //MARK: Setup Add Task
            case .add:
                deleteLabel.removeFromSuperview()
                deleteButton.removeFromSuperview()
                
                //MARK: Setup Done Button
                let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
                navigationItem.rightBarButtonItem = doneButton
            }
            
        }
        
        
    }
    
    //MARK: - Add/Save Task
    @objc func doneButtonTapped() {
        if let actionTask = ActionTask {
            switch actionTask{
                
                //MARK: Add Task
            case .add:
                if titleTextField.text == ""{
                    let ac = UIAlertController(title: title, message: "Title cannot empty", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    present(ac, animated: true)
                }else{
                    
                    let newTask = Task(title: titleTextField.text! , dueDate: dateAndTime.date, note: textView.text, isCompleted: false)
                    RealmManager.shared.addTask(task: newTask)
                    delegate?.reloadView()
                    
                    NotificationManager.shared.AddNotification(newid: newTask.id, title: titleTextField.text!, note: textView.text, dueDate: dateAndTime.date)
                    dismiss(animated: true, completion: nil)
                    
                }
                //MARK: Edit Task
            case .edit:
                RealmManager.shared.updateDueDateTask(Id: id!, newDueDate: dateAndTime.date)
                NotificationManager.shared.updateNotification(id: id!, title: titleTextField.text!, note: textView.text, dueDate: dateAndTime.date)
                dismiss(animated: true, completion: nil)
                
                
            }
        }
    }
    
    
    //MARK: - Cancel Action
    @objc func cancelButtonTapped(action: UIAlertAction! = nil) {
        // Xử lý khi nút "Cancel" được nhấn, nếu cần
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Delete Task
    func DeleteTapped(action: UIAlertAction! = nil){
        RealmManager.shared.deleteTask(id: id!)
        center.removePendingNotificationRequests(withIdentifiers: [id!])
        dismiss(animated: true, completion: nil)
        delegatePOP?.popToRootController()
        //        self.navigationController!.popToRootViewController(animated: true)
        
    }
    
    //MARK: - Alert Delete Task
    @IBAction func DeleteAction(_ sender: UIButton) {
        let ac = UIAlertController(title: title, message: "Want to delete?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: DeleteTapped))
        present(ac, animated: true)
    }
}


extension UIDatePicker {
    
    var textColor: UIColor? {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
}
