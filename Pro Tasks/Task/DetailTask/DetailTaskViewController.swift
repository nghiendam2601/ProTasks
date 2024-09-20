

import UIKit

class DetailTaskViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet var TitleTask: UITextView!
    @IBOutlet var NoteTask: UITextView!
    @IBOutlet var NoteTextView: UITextView!
    @IBOutlet var TitleTextView: UITextView!
    
    //MARK: - Properties
    var noteTask: String?
    var titleTask: String?
    var id: String?
    var delegate: ReloadDelegate?
    var hasChangedText: Bool = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Setup Delegate
        TitleTextView.delegate = self
        NoteTextView.delegate = self
        
        
        //MARK: SetUp Title & Note
        if let titleTask = titleTask{
            TitleTask.text = titleTask
        }
        if let noteTask = noteTask{
            NoteTask.text = noteTask
        }

        //MARK: setup edit action
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editAction))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reload view when delete task (ActionTaskController)
        delegate?.reloadView()
    }
    //MARK: - SegueToEdit
    @objc func editAction(){
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            if let navigationController = segue.destination as? UINavigationController,
               let ActionTaskController = navigationController.topViewController as? ActionTaskViewController {
                ActionTaskController.ActionTask = .edit
                ActionTaskController.id = id!
                ActionTaskController.delegatePOP = self
            }
        }
    }
}

//MARK: - Return Home View
extension DetailTaskViewController: PopToRootController{
    func popToRootController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - TextViewDelegate
extension DetailTaskViewController: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        // Save the content when editing ends
        if hasChangedText{
            if TitleTextView.text == ""{
                TitleTextView.text = titleTask
            }else{
                RealmManager.shared.updateTask(Id: id!, Title: TitleTextView.text, Node: NoteTextView.text)
                let newDueDate = RealmManager.shared.getDueDateTask(Id: id!)
                NotificationManager.shared.updateNotification(id: id!, title: TitleTextView.text, note: NoteTextView.text, dueDate: newDueDate)
                titleTask = TitleTextView.text
                hasChangedText = false
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if !hasChangedText {
            hasChangedText = true
        }
    }
}
