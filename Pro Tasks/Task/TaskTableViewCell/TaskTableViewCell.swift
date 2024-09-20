

import UIKit

class TaskTableViewCell: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet var ButtonTask: UIButton!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var TitleLabel: UILabel!
    
    //MARK: - Properties
    var idTask: String?

    //MARK: - Nib setup
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }
    //MARK: - CompletedTask
    @IBAction func DoneAction(_ sender: UIButton) {
        if let IdTask = idTask{
            RealmManager.shared.updateIsCompletedTasks(Id: IdTask)
            let newTask = RealmManager.shared.getTask(ID: IdTask)
            if newTask.isCompleted == true{
                ButtonTask.setImage(Config.circleFillIcon, for: .normal)
                TitleLabel.attributedText = NSAttributedString(string: TitleLabel.text!, attributes: Config.attributes)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [IdTask])
            }else{
                ButtonTask.setImage(Config.circleIcon, for: .normal)
                TitleLabel.attributedText = NSAttributedString(string: TitleLabel.text!, attributes: Config.attributesNormal)
                NotificationManager.shared.AddNotification(newid: IdTask, title: newTask.title, note: newTask.note, dueDate: newTask.dueDate)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
